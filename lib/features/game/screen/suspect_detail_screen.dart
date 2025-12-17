import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/controller/suspect_detail_provider.dart';
import 'package:alqadiya_game/features/game/controller/game_timer_controller.dart';
import 'package:alqadiya_game/features/game/widget/suspect_detail/audio_player_widget.dart';
import 'package:alqadiya_game/features/game/widget/suspect_detail/image_preview_screen.dart';
import 'package:alqadiya_game/features/game/widget/suspect_detail/pdf_viewer.dart';
import 'package:alqadiya_game/features/game/widget/suspect_detail/video_player_screen.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/game_footer.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class SuspectDetailScreen extends StatelessWidget {
  const SuspectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the existing timer controller (should already be initialized from game_screen)
    // If not found, create it (fallback scenario)
    final timerController =
        Get.isRegistered<GameTimerController>()
              ? Get.find<GameTimerController>()
              : Get.put(GameTimerController(), permanent: true)
          ..startTimer();

    // Initialize suspect detail controller
    final suspectController = Get.find<SuspectDetailController>();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        imageUrl: "https://picsum.photos/200",
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
                      'List of suspects'.tr,
                      style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Panel - Suspect Portrait
                    _buildSuspectPortrait(),

                    SizedBox(width: 8.w),

                    // Right Panel - Content Area
                    Expanded(
                      child: Column(
                        children: [
                          // Main Navigation Tabs
                          Obx(() => _buildMainTabs(suspectController)),

                          SizedBox(height: 10.h),

                          // Content Area
                          Expanded(
                            child: Obx(
                              () => _buildContentArea(suspectController),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 5.sp),
              child: GameFooter(onGameResultTap: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuspectPortrait() {
    return Container(
      width: 0.2.sw,
      height: double.infinity,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
      child: Image.asset(MyImages.suspect, fit: BoxFit.cover),
    );
  }

  Widget _buildMainTabs(SuspectDetailController controller) {
    final tabs = [
      'Personal information',
      'Attachments',
      'Investigation report',
    ];

    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = controller.selectedMainTab.value == index;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              controller.setSelectedMainTab(index);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? MyColors.redButtonColor
                        : MyColors.black.withValues(alpha: 0.2),
                borderRadius:
                    index == 1
                        ? null
                        : index == 0
                        ? BorderRadius.only(
                          topLeft: Radius.circular(100.r),
                          bottomLeft: Radius.circular(100.r),
                        )
                        : BorderRadius.only(
                          topRight: Radius.circular(100.r),
                          bottomRight: Radius.circular(100.r),
                        ),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: AppTextStyles.heading4().copyWith(
                    fontSize: 6.sp,
                    color: MyColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContentArea(SuspectDetailController controller) {
    if (controller.selectedMainTab.value == 0) {
      return _buildPersonalInformation();
    } else if (controller.selectedMainTab.value == 1) {
      return _buildAttachments(controller);
    } else if (controller.selectedMainTab.value == 2) {
      return _buildInvestigationReport(controller);
    }
    return _buildPersonalInformation();
  }

  Widget _buildPersonalInformation() {
    final scrollController = ScrollController();
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personal Information Fields
                    _buildInfoField('Full Name:', 'Azmi Kame'),
                    SizedBox(height: 6.h),
                    _buildInfoField('Age:', '54 years old'),
                    SizedBox(height: 6.h),
                    _buildInfoField('Job:', 'Unemployed for 10 years'),

                    SizedBox(height: 12.h),

                    // Descriptive Paragraph
                    Text(
                      'Overindulgence in financial problems and impulsive spending is a common problem that hinders financial stability. Some people find it difficult to control their spending habits and often overindulge in financial problems and impulsive spending is a common problem that hinders financial stability. Some people find it difficult to control their spending habits and often overindulge in financial problems and impulsive spending is a common problem.',
                      style: AppTextStyles.bodyTextRegular16().copyWith(
                        fontSize: 6.sp,
                        color: MyColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Custom Scrollbar
          _buildCustomScrollbar(scrollController),
        ],
      ),
    );
  }

  Widget _buildCustomScrollbar(ScrollController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            if (!controller.hasClients ||
                !controller.position.hasContentDimensions) {
              return SizedBox(width: 1.w);
            }

            try {
              final scrollPosition = controller.position;
              final maxScrollExtent = scrollPosition.maxScrollExtent;
              final minScrollExtent = scrollPosition.minScrollExtent;
              final scrollOffset = scrollPosition.pixels;

              if (maxScrollExtent <= 0 ||
                  !scrollPosition.hasContentDimensions) {
                return SizedBox(width: 1.w);
              }

              final trackHeight = constraints.maxHeight;
              if (trackHeight <= 0) {
                return SizedBox(width: 1.w);
              }

              final thumbHeight = (trackHeight *
                      trackHeight /
                      (maxScrollExtent + trackHeight))
                  .clamp(20.0, trackHeight);

              final scrollRange = maxScrollExtent - minScrollExtent;
              if (scrollRange <= 0) {
                return SizedBox(width: 1.w);
              }

              final thumbOffset =
                  ((scrollOffset - minScrollExtent) / scrollRange) *
                  (trackHeight - thumbHeight);

              return GestureDetector(
                onPanUpdate: (details) {
                  if (!controller.hasClients ||
                      !controller.position.hasContentDimensions)
                    return;
                  try {
                    final delta = details.delta.dy;
                    final newOffset =
                        (thumbOffset + delta) /
                            (trackHeight - thumbHeight) *
                            scrollRange +
                        minScrollExtent;
                    controller.jumpTo(
                      newOffset.clamp(minScrollExtent, maxScrollExtent),
                    );
                  } catch (e) {
                    // Ignore errors during pan update
                  }
                },
                onTapDown: (details) {
                  if (!controller.hasClients ||
                      !controller.position.hasContentDimensions)
                    return;
                  try {
                    final localY = details.localPosition.dy;
                    final newOffset =
                        (localY / trackHeight) * scrollRange + minScrollExtent;
                    controller.jumpTo(
                      newOffset.clamp(minScrollExtent, maxScrollExtent),
                    );
                  } catch (e) {
                    // Ignore errors during tap down
                  }
                },
                child: Container(
                  width: 1.w,
                  height: trackHeight,
                  child: Stack(
                    children: [
                      // Track - white line showing full scrollable area
                      Container(
                        width: 1.w,
                        height: trackHeight,
                        color: Color(0xffD9D9D9).withValues(alpha: 0.1),
                      ),
                      // Thumb - shows current scroll position
                      Positioned(
                        top: thumbOffset.clamp(0.0, trackHeight - thumbHeight),
                        child: Container(
                          width: 1.w,
                          height: thumbHeight,
                          decoration: BoxDecoration(
                            color: MyColors.redButtonColor,
                            borderRadius: BorderRadius.circular(0.5.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } catch (e) {
              return SizedBox(width: 1.w);
            }
          },
        );
      },
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 0.12.sw,
          child: Text(
            label,
            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          ' $value',
          style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildAttachments(SuspectDetailController controller) {
    return Obx(() {
      if (controller.selectedAttachmentType.value == null) {
        return _buildAttachmentsGrid(controller);
      } else if (controller.selectedAttachmentType.value == 'Videos') {
        return _buildVideosList(controller);
      } else if (controller.selectedAttachmentType.value == 'Images') {
        return _buildImagesList(controller);
      } else if (controller.selectedAttachmentType.value == 'Documents') {
        return _buildDocumentsList(controller);
      } else if (controller.selectedAttachmentType.value == 'Audio') {
        return _buildAudioList(controller);
      }
      return _buildAttachmentsGrid(controller);
    });
  }

  Widget _buildAttachmentsGrid(SuspectDetailController suspectController) {
    final attachmentTypes = [
      {'icon': MyIcons.videos, 'label': 'Videos', 'type': 'Videos'},
      {'icon': MyIcons.gallery, 'label': 'Images', 'type': 'Images'},
      {'icon': MyIcons.document, 'label': 'Documents', 'type': 'Documents'},
      {'icon': MyIcons.audios, 'label': 'Audio', 'type': 'Audio'},
    ];

    return Container(
      // padding: EdgeInsets.all(10.w),
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
          return GestureDetector(
            onTap: () {
              suspectController.setSelectedAttachmentType(
                item['type'] as String,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.BlueColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(item['icon'] as String),
                  SizedBox(height: 5.h),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 6.sp,
                      color: MyColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideosList(SuspectDetailController suspectController) {
    final videos = [
      'https://picsum.photos/300/200?random=1',
      'https://picsum.photos/300/200?random=2',
      'https://picsum.photos/300/200?random=3',
    ];

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
                onTap: () => suspectController.resetAttachmentType(),
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
                return GestureDetector(
                  onTap: () {
                    // Navigate to video player
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => VideoPlayerScreen(
                              videoUrl:
                                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
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
                            imageUrl: videos[index],
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

  Widget _buildImagesList(SuspectDetailController suspectController) {
    final images = [
      'https://picsum.photos/300/200?random=4',
      'https://picsum.photos/300/200?random=5',
      'https://picsum.photos/300/200?random=6',
    ];

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
                onTap: () => suspectController.resetAttachmentType(),
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ImagePreviewScreen(imageUrl: images[index]),
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
                        imageUrl: images[index],
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

  Widget _buildDocumentsList(SuspectDetailController suspectController) {
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
                onTap: () => suspectController.resetAttachmentType(),
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
              itemCount: 3,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PDFViewerScreen(
                              pdfUrl:
                                  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
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
                            'Document 1',
                            style: AppTextStyles.heading2().copyWith(
                              fontSize: 6.sp,
                              color: MyColors.BlueColor,
                            ),
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

  Widget _buildAudioList(SuspectDetailController suspectController) {
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
                onTap: () => suspectController.resetAttachmentType(),
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
              itemCount: 1,
              itemBuilder: (context, index) {
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
                      audioUrl:
                          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                      title: 'Audio 1',
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

  Widget _buildInvestigationReport(SuspectDetailController suspectController) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 2.5,
      ),
      itemCount: 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PDFViewerScreen(
                        pdfUrl:
                            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                      ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.BlueColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(MyIcons.document, height: 30.h),
                  SizedBox(height: 8.h),
                  Text(
                    'Investigation report',
                    style: AppTextStyles.heading1().copyWith(
                      fontSize: 8.sp,
                      color: MyColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () {
              suspectController.setSelectedMainTab(1);
              suspectController.setSelectedAttachmentType('Audio');
            },
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.BlueColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(MyIcons.audios, height: 30.h),
                  SizedBox(height: 8.h),
                  Text(
                    'Audios',
                    style: AppTextStyles.heading1().copyWith(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: MyColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
