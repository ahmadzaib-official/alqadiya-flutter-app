import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/controller/clue_detail_provider.dart';
import 'package:alqadiya_game/features/game/controller/evidence_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_timer_controller.dart';
import 'package:alqadiya_game/features/game/widget/suspect_detail/audio_player_widget.dart';
import 'package:alqadiya_game/features/game/widget/suspect_detail/image_preview_screen.dart';
import 'package:alqadiya_game/features/game/widget/suspect_detail/pdf_viewer.dart';
import 'package:alqadiya_game/features/game/widget/suspect_detail/video_player_screen.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/game_footer.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ClueDetailScreen extends StatefulWidget {
  const ClueDetailScreen({super.key});

  @override
  State<ClueDetailScreen> createState() => _ClueDetailScreenState();
}

class _ClueDetailScreenState extends State<ClueDetailScreen> {
  @override
  void initState() {
    super.initState();
    final evidenceController = Get.find<EvidenceController>();
    final arguments = Get.arguments as Map<String, dynamic>?;
    final evidenceId = arguments?['evidenceId'];

    if (evidenceId != null) {
      evidenceController.getEvidenceById(evidenceId: evidenceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the existing timer controller (should already be initialized from game_screen)
    // If not found, create it (fallback scenario)
    final timerController =
        Get.isRegistered<GameTimerController>()
              ? Get.find<GameTimerController>()
              : Get.put(GameTimerController(), permanent: true)
          ..startTimer();

    // Initialize clue detail controller
    final clueController = Get.find<ClueDetailController>();
    final evidenceController = Get.find<EvidenceController>();
    final gameController = Get.find<GameController>();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Obx(
        () => GameBackground(
          isPurchased: true,
          imageUrl:
              gameController.gameDetail.value?.coverImageUrl ??
              gameController.gameDetail.value?.coverImage ??
              "https://picsum.photos/200",
          body: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 5.sp),
                child: HomeHeader(
                  onChromTap: () {},
                  title: Row(
                    children: [
                      Text(
                        evidenceController.evidenceDetail.value?.evidenceName ??
                            gameController.gameDetail.value?.title ??
                            'New Clue'.tr,
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'Timer '.tr,
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 10.sp,
                          color: MyColors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      Obx(
                        () => Text(
                          timerController.timerText.value,
                          style: AppTextStyles.heading1().copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actionButtons: GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset(MyIcons.arrowbackrounded),
                  ),
                ),
              ),

              SizedBox(height: 5.h),

              // Main Content
              Expanded(
                child: Obx(() {
                  if (evidenceController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: MyColors.redButtonColor,
                      ),
                    );
                  }

                  if (evidenceController.evidenceDetail.value == null) {
                    return Center(
                      child: Text(
                        'No evidence details available'.tr,
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 10.sp,
                          color: MyColors.white,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Panel - Clue Image
                        _buildClueImage(
                          evidenceController.evidenceDetail.value!,
                        ),

                        SizedBox(width: 8.w),

                        // Right Panel - Content Area
                        Expanded(
                          child: Column(
                            children: [
                              // Tab Bar
                              _buildTabBar(clueController),

                              SizedBox(height: 10.h),

                              // Content Area
                              Expanded(
                                child: _buildContentArea(
                                  clueController,
                                  evidenceController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              // Footer
              Padding(
                padding: EdgeInsets.only(
                  left: 10.sp,
                  right: 10.sp,
                  bottom: 5.sp,
                ),
                child: GameFooter(onGameResultTap: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClueImage(evidence) {
    return Container(
      width: 0.2.sw,
      height: double.infinity,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r)),
      ),
      child: CachedNetworkImage(
        imageUrl:
            evidence.profileImageURL ??
            evidence.profileImage ??
            "https://picsum.photos/200",
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(
              color: MyColors.darkBlueColor,
              child: Center(
                child: CircularProgressIndicator(
                  color: MyColors.redButtonColor,
                ),
              ),
            ),
        errorWidget:
            (context, url, error) =>
                Image.asset(MyImages.suspect, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTabBar(ClueDetailController controller) {
    return Row(
      children: [
        // Clue Information Tab
        // Expanded(
        //   child: GestureDetector(
        //     onTap: () => controller.setSelectedTab(0),
        //     child: Container(
        //       padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
        //       decoration: BoxDecoration(
        //         color:
        //             controller.selectedTab.value == 0
        //                 ? MyColors.redButtonColor
        //                 : MyColors.black.withValues(alpha: 0.2),
        //         borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(100.r),
        //           bottomLeft: Radius.circular(100.r),
        //         ),
        //       ),
        //       child: Center(
        //         child: Text(
        //           'Clue Information'.tr,
        //           style: AppTextStyles.heading2().copyWith(
        //             fontSize: 7.sp,
        //             color:
        //                 controller.selectedTab.value == 0
        //                     ? MyColors.white
        //                     : MyColors.white.withValues(alpha: 0.5),
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        // Attachments Tab
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
          decoration: BoxDecoration(
            color:
                // controller.selectedTab.value == 1
                //     ?
                MyColors.redButtonColor,
            // : MyColors.black.withValues(alpha: 0.2)

            // borderRadius: BorderRadius.only(
            //   topRight: Radius.circular(100.r),
            //   bottomRight: Radius.circular(100.r),
            // ),
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Center(
            child: Text(
              'Attachments'.tr,
              style: AppTextStyles.heading2().copyWith(
                fontSize: 7.sp,
                color:
                    // controller.selectedTab.value == 1
                    //     ?
                    MyColors.white,
                // : MyColors.white.withValues(alpha: 0.5)
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentArea(
    ClueDetailController controller,
    EvidenceController evidenceController,
  ) {
    final evidence = evidenceController.evidenceDetail.value;
    if (evidence == null) {
      return Center(
        child: Text(
          'No evidence details'.tr,
          style: AppTextStyles.heading1().copyWith(
            fontSize: 8.sp,
            color: MyColors.white,
          ),
        ),
      );
    }

    if (controller.selectedAttachmentType.value == null) {
      return _buildAttachmentsGrid(controller, evidence);
    } else if (controller.selectedAttachmentType.value == 'Videos') {
      return _buildVideosList(controller, evidence);
    } else if (controller.selectedAttachmentType.value == 'Images') {
      return _buildImagesList(controller, evidence);
    } else if (controller.selectedAttachmentType.value == 'Documents') {
      return _buildDocumentsList(controller, evidence);
    } else if (controller.selectedAttachmentType.value == 'Audio') {
      return _buildAudioList(controller, evidence);
    }
    return _buildAttachmentsGrid(controller, evidence);
  }

  Widget _buildAttachmentsGrid(ClueDetailController controller, evidence) {
    final attachments = evidence.attachments ?? [];
    final attachmentTypes = [
      {
        'icon': MyIcons.videos,
        'label': 'Videos',
        'type': 'Videos',
        'count':
            attachments
                .where((a) => a.attachmentType?.toLowerCase() == 'video')
                .length,
      },
      {
        'icon': MyIcons.gallery,
        'label': 'Images',
        'type': 'Images',
        'count':
            attachments
                .where((a) => a.attachmentType?.toLowerCase() == 'image')
                .length,
      },
      {
        'icon': MyIcons.audios,
        'label': 'Audio',
        'type': 'Audio',
        'count':
            attachments
                .where((a) => a.attachmentType?.toLowerCase() == 'audio')
                .length,
      },
      {
        'icon': MyIcons.document,
        'label': 'Documents',
        'type': 'Documents',
        'count':
            attachments
                .where((a) => a.attachmentType?.toLowerCase() == 'document')
                .length,
      },
    ];

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 2,
        ),
        itemCount: attachmentTypes.length,
        itemBuilder: (context, index) {
          final item = attachmentTypes[index];
          final count = item['count'] as int;

          return GestureDetector(
            onTap: () {
              controller.setSelectedAttachmentType(item['type'] as String);
            },
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.BlueColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    item['icon'] as String,
                    height: 30.h,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    item['label'] as String,
                    style: AppTextStyles.heading1().copyWith(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: MyColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (count > 0) ...[
                    SizedBox(height: 4.h),
                    Text(
                      '($count)',
                      style: AppTextStyles.heading2().copyWith(
                        fontSize: 6.sp,
                        color: MyColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideosList(ClueDetailController controller, evidence) {
    final videos =
        (evidence.attachments ?? [])
            .where((a) => a.attachmentType?.toLowerCase() == 'video')
            .toList();

    if (videos.isEmpty) {
      return Center(
        child: Text(
          'No videos available'.tr,
          style: AppTextStyles.heading1().copyWith(
            fontSize: 8.sp,
            color: MyColors.white,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: MyColors.BlueColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and refresh
          Row(
            children: [
              SvgPicture.asset(MyIcons.videos, height: 10.sp),
              SizedBox(width: 5.w),
              Text(
                'Videos',
                style: AppTextStyles.heading2().copyWith(
                  fontSize: 8.sp,
                  color: MyColors.white,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => controller.resetAttachmentType(),
                child: SvgPicture.asset(MyIcons.arrowbackNoBackground),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Divider(color: Colors.white.withValues(alpha: 0.1)),
          SizedBox(height: 5.h),

          // Video thumbnails
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to video player
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => VideoPlayerScreen(
                              videoUrl: video.mediaUrl ?? '',
                            ),
                      ),
                    );
                  },
                  child: Container(
                    width: 60.w,
                    margin: EdgeInsets.only(right: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: CachedNetworkImage(
                            imageUrl:
                                video.thumbnailUrl ??
                                video.mediaUrl ??
                                "https://picsum.photos/300/200",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  color: MyColors.darkBlueColor,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: MyColors.redButtonColor,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: MyColors.darkBlueColor,
                                  child: Icon(
                                    Icons.error,
                                    color: MyColors.white,
                                  ),
                                ),
                          ),
                        ),
                        // Play button overlay
                        Positioned.fill(
                          child: Center(
                            child: Icon(
                              Icons.play_arrow_outlined,
                              color: MyColors.white.withValues(alpha: 0.5),
                              size: 30.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesList(ClueDetailController controller, evidence) {
    final images =
        (evidence.attachments ?? [])
            .where((a) => a.attachmentType?.toLowerCase() == 'image')
            .toList();

    if (images.isEmpty) {
      return Center(
        child: Text(
          'No images available'.tr,
          style: AppTextStyles.heading1().copyWith(
            fontSize: 8.sp,
            color: MyColors.white,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: MyColors.BlueColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and refresh
          Row(
            children: [
              SvgPicture.asset(MyIcons.gallery, height: 10.sp),
              SizedBox(width: 5.w),
              Text(
                'Images',
                style: AppTextStyles.heading2().copyWith(
                  fontSize: 8.sp,
                  color: MyColors.white,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => controller.resetAttachmentType(),
                child: SvgPicture.asset(MyIcons.arrowbackNoBackground),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Divider(color: Colors.white.withValues(alpha: 0.1)),
          SizedBox(height: 5.h),
          // Image thumbnails
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ImagePreviewScreen(
                              imageUrl: image.mediaUrl ?? '',
                            ),
                      ),
                    );
                  },
                  child: Container(
                    width: 60.w,
                    margin: EdgeInsets.only(right: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedNetworkImage(
                        imageUrl:
                            image.mediaUrl ?? "https://picsum.photos/300/200",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              color: MyColors.darkBlueColor,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: MyColors.redButtonColor,
                                ),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: MyColors.darkBlueColor,
                              child: Icon(Icons.error, color: MyColors.white),
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(ClueDetailController controller, evidence) {
    final documents =
        (evidence.attachments ?? [])
            .where((a) => a.attachmentType?.toLowerCase() == 'document')
            .toList();

    if (documents.isEmpty) {
      return Center(
        child: Text(
          'No documents available'.tr,
          style: AppTextStyles.heading1().copyWith(
            fontSize: 8.sp,
            color: MyColors.white,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: MyColors.BlueColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and refresh
          Row(
            children: [
              SvgPicture.asset(MyIcons.document, height: 10.sp),
              SizedBox(width: 5.w),
              Text(
                'Documents',
                style: AppTextStyles.heading2().copyWith(
                  fontSize: 8.sp,
                  color: MyColors.white,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => controller.resetAttachmentType(),
                child: SvgPicture.asset(MyIcons.arrowbackNoBackground),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Divider(color: Colors.white.withValues(alpha: 0.1)),
          SizedBox(height: 5.h),
          // Document button
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              scrollDirection: Axis.horizontal,
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PDFViewerScreen(
                              pdfUrl: document.mediaUrl ?? '',
                            ),
                      ),
                    );
                  },
                  child: Container(
                    width: 60.w,
                    margin: EdgeInsets.only(right: 10.w),
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        gradient: RadialGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0),
                            Colors.black.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(MyIcons.file),
                          SizedBox(height: 8.h),
                          Text(
                            document.attachmentNameEn ??
                                'Document ${index + 1}',
                            style: AppTextStyles.heading2().copyWith(
                              fontSize: 6.sp,
                              color: MyColors.BlueColor,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioList(ClueDetailController controller, evidence) {
    final audios =
        (evidence.attachments ?? [])
            .where((a) => a.attachmentType?.toLowerCase() == 'audio')
            .toList();

    if (audios.isEmpty) {
      return Center(
        child: Text(
          'No audio available'.tr,
          style: AppTextStyles.heading1().copyWith(
            fontSize: 8.sp,
            color: MyColors.white,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: MyColors.BlueColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and refresh
          Row(
            children: [
              SvgPicture.asset(MyIcons.audios, height: 10.sp),
              SizedBox(width: 5.w),
              Text(
                'Audio',
                style: AppTextStyles.heading2().copyWith(
                  fontSize: 8.sp,
                  color: MyColors.white,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => controller.resetAttachmentType(),
                child: SvgPicture.asset(MyIcons.arrowbackNoBackground),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Divider(color: Colors.white.withValues(alpha: 0.1)),
          SizedBox(height: 5.h),
          // Audio players
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              scrollDirection: Axis.horizontal,
              itemCount: audios.length,
              itemBuilder: (context, index) {
                final audio = audios[index];
                return Container(
                  width: 60.w,
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: RadialGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0),
                          Colors.black.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                    child: AudioPlayerWidget(
                      audioUrl: audio.mediaUrl ?? '',
                      title:
                          audio.attachmentNameEn ??
                          '${'Audio'.tr} ${index + 1}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildClueInformation() {
  //   final scrollController = ScrollController();
  //   return Container(
  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Scrollable content
  //         Expanded(
  //           child: SingleChildScrollView(
  //             controller: scrollController,
  //             child: Padding(
  //               padding: EdgeInsets.only(right: 8.w),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Clue Name
  //                   _buildInfoField(
  //                     'Clue Name:',
  //                     'Private information about the victim',
  //                   ),

  //                   SizedBox(height: 6.h),

  //                   // Discovery Date
  //                   _buildInfoField('Discovery Date:', '16ᵗʰ July 2025'),

  //                   SizedBox(height: 12.h),

  //                   // Description Paragraph
  //                   Text(
  //                     'The victim is raised in a family as a result of violence and may suffer from chronic health problems, illnesses, financial distress, and a weakened ability to establish healthy relationships. The victim is raised in a family as a result of violence and may suffer from chronic health problems, illnesses, financial distress, and a weakened ability to establish healthy relationships. The victim is raised in a family as a result of violence and may suffer from chronic health problems, illnesses, financial distress, and a weakened ability to establish healthy relationships.',
  //                     style: TextStyle(
  //                       fontSize: 6.sp,
  //                       color: MyColors.white,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                     textAlign: TextAlign.left,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),

  //         // Custom Scrollbar
  //         _buildCustomScrollbar(scrollController),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildCustomScrollbar(ScrollController controller) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       return ListenableBuilder(
  //         listenable: controller,
  //         builder: (context, child) {
  //           if (!controller.hasClients ||
  //               !controller.position.hasContentDimensions) {
  //             return SizedBox(width: 1.w);
  //           }

  //           try {
  //             final scrollPosition = controller.position;
  //             final maxScrollExtent = scrollPosition.maxScrollExtent;
  //             final minScrollExtent = scrollPosition.minScrollExtent;
  //             final scrollOffset = scrollPosition.pixels;

  //             if (maxScrollExtent <= 0 ||
  //                 !scrollPosition.hasContentDimensions) {
  //               return SizedBox(width: 1.w);
  //             }

  //             final trackHeight = constraints.maxHeight;
  //             if (trackHeight <= 0) {
  //               return SizedBox(width: 1.w);
  //             }

  //             final thumbHeight = (trackHeight *
  //                     trackHeight /
  //                     (maxScrollExtent + trackHeight))
  //                 .clamp(20.0, trackHeight);

  //             final scrollRange = maxScrollExtent - minScrollExtent;
  //             if (scrollRange <= 0) {
  //               return SizedBox(width: 1.w);
  //             }

  //             final thumbOffset =
  //                 ((scrollOffset - minScrollExtent) / scrollRange) *
  //                 (trackHeight - thumbHeight);

  //             return GestureDetector(
  //               onPanUpdate: (details) {
  //                 if (!controller.hasClients ||
  //                     !controller.position.hasContentDimensions)
  //                   return;
  //                 try {
  //                   final delta = details.delta.dy;
  //                   final newOffset =
  //                       (thumbOffset + delta) /
  //                           (trackHeight - thumbHeight) *
  //                           scrollRange +
  //                       minScrollExtent;
  //                   controller.jumpTo(
  //                     newOffset.clamp(minScrollExtent, maxScrollExtent),
  //                   );
  //                 } catch (e) {
  //                   // Ignore errors during pan update
  //                 }
  //               },
  //               onTapDown: (details) {
  //                 if (!controller.hasClients ||
  //                     !controller.position.hasContentDimensions)
  //                   return;
  //                 try {
  //                   final localY = details.localPosition.dy;
  //                   final newOffset =
  //                       (localY / trackHeight) * scrollRange + minScrollExtent;
  //                   controller.jumpTo(
  //                     newOffset.clamp(minScrollExtent, maxScrollExtent),
  //                   );
  //                 } catch (e) {
  //                   // Ignore errors during tap down
  //                 }
  //               },
  //               child: Container(
  //                 width: 1.w,
  //                 height: trackHeight,
  //                 child: Stack(
  //                   children: [
  //                     // Track - white line showing full scrollable area
  //                     Container(
  //                       width: 1.w,
  //                       height: trackHeight,
  //                       color: Color(0xffD9D9D9).withValues(alpha: 0.1),
  //                     ),
  //                     // Thumb - shows current scroll position
  //                     Positioned(
  //                       top: thumbOffset.clamp(0.0, trackHeight - thumbHeight),
  //                       child: Container(
  //                         width: 1.w,
  //                         height: thumbHeight,
  //                         decoration: BoxDecoration(
  //                           color: MyColors.redButtonColor,
  //                           borderRadius: BorderRadius.circular(0.5.r),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           } catch (e) {
  //             return SizedBox(width: 1.w);
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

  // Widget _buildInfoField(String label, String value) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         width: 0.16.sw,
  //         child: Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 6.sp,
  //             fontWeight: FontWeight.w500,
  //             color: MyColors.white,
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: Text(
  //           value,
  //           style: TextStyle(
  //             fontSize: 6.sp,
  //             fontWeight: FontWeight.w700,
  //             color: MyColors.white,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
