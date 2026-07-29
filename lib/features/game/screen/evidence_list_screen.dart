import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:intl/intl.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
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

class EvidenceListScreen extends StatefulWidget {
  const EvidenceListScreen({super.key});

  @override
  State<EvidenceListScreen> createState() => _EvidenceListScreenState();
}

class _EvidenceListScreenState extends State<EvidenceListScreen> {
  // 0 = Clues, 1 = Attachments
  final RxInt selectedTab = 0.obs;

  // Selected attachment type inside Attachments tab (null = grid)
  final Rx<String?> selectedAttachmentType = Rx<String?>(null);

  final RxBool showGrid = true.obs;
  final Rx<dynamic> selectedEvidence = Rx<dynamic>(null);

  @override
  void initState() {
    super.initState();
    final evidenceController = Get.find<EvidenceController>();
    final gameController = Get.find<GameController>();

    final gameId =
        gameController.gameDetail.value.id ??
        gameController.gameSession.value?.gameId;
    if (gameId != null) {
      evidenceController.getEvidencesByGame(gameId: gameId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerController =
        Get.isRegistered<GameTimerController>()
              ? Get.find<GameTimerController>()
              : Get.put(GameTimerController(), permanent: true)
          ..startTimer();

    final evidenceController = Get.find<EvidenceController>();
    final gameController = Get.find<GameController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (!showGrid.value) {
          showGrid.value = true;
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: Obx(
          () => GameBackground(
            isPurchased: true,
            imageUrl:
                gameController.gameDetail.value.coverImageUrl ??
                gameController.gameDetail.value.coverImage ??
                "https://picsum.photos/200",
            body: Column(
              children: [
                // ── Header ──────────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.sp,
                    right: 10.sp,
                    top: 5.sp,
                  ),
                  child: HomeHeader(
                    title: Row(
                      children: [
                        Obx(() => Text(
                          showGrid.value
                              ? 'List of evidence'.tr
                              : (gameController.gameDetail.value.title ?? 'List of evidence'.tr),
                          style: AppTextStyles.heading1().copyWith(
                            fontSize: 10.sp,
                          ),
                        )),
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
                      onTap: () {
                        if (!showGrid.value) {
                          showGrid.value = true;
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: SvgPicture.asset(MyIcons.arrowbackrounded),
                    ),
                  ),
                ),

                SizedBox(height: 5.h),

                // ── Main Content ─────────────────────────────────────────────
                Expanded(
                  child: Obx(() {
                    if (showGrid.value) {
                      return _buildEnvelopeGrid(evidenceController);
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Panel
                          _buildLeftImage(gameController, evidenceController),

                          SizedBox(width: 8.w),

                          // Right Panel
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Narrow Tabs
                                _buildTabs(),

                                SizedBox(height: 10.h),

                                // Tab Content
                                Expanded(
                                  child: Obx(() {
                                    if (selectedTab.value == 0) {
                                      return _buildCluesTab(evidenceController);
                                    } else {
                                      return _buildAttachmentsTab(
                                        evidenceController,
                                      );
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),

                // ── Footer ───────────────────────────────────────────────────
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
      ),
    );
  }

  // ─── Left Image Panel ──────────────────────────────────────────────────────

  Widget _buildLeftImage(
    GameController gameController,
    EvidenceController evidenceController,
  ) {
    return Obx(() {
      final currentEvidence = selectedEvidence.value;

      final imageUrl =
          currentEvidence?.profileImageURL ??
          currentEvidence?.profileImage ??
          gameController.gameDetail.value.coverImageUrl ??
          gameController.gameDetail.value.coverImage ??
          "https://picsum.photos/200";

      return Container(
        width: 0.2.sw,
        height: double.infinity,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
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
    });
  }

  // ─── Narrow Tabs ──────────────────────────────────────────────────────────
  // mainAxisSize.min = tabs only as wide as their content (not full width)

  Widget _buildTabs() {
    final tabs = ['Clues', 'Attachments'];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(tabs.length, (index) {
        final isSelected = selectedTab.value == index;
        return GestureDetector(
          onTap: () {
            selectedTab.value = index;
            selectedAttachmentType.value = null;
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? MyColors.redButtonColor
                      : MyColors.black.withValues(alpha: 0.2),
              borderRadius:
                  index == 0
                      ? BorderRadius.only(
                        topLeft: Radius.circular(
                          Get.locale?.languageCode == 'ar' ? 0 : 100.r,
                        ),
                        bottomLeft: Radius.circular(
                          Get.locale?.languageCode == 'ar' ? 0 : 100.r,
                        ),
                        topRight: Radius.circular(
                          Get.locale?.languageCode == 'ar' ? 100.r : 0,
                        ),
                        bottomRight: Radius.circular(
                          Get.locale?.languageCode == 'ar' ? 100.r : 0,
                        ),
                      )
                      : BorderRadius.only(
                        topRight: Radius.circular(
                          Get.locale?.languageCode == 'ar' ? 0 : 100.r,
                        ),
                        bottomRight: Radius.circular(
                          Get.locale?.languageCode == 'ar' ? 0 : 100.r,
                        ),
                        topLeft: Radius.circular(
                          Get.locale?.languageCode == 'ar' ? 100.r : 0,
                        ),
                        bottomLeft: Radius.circular(
                          Get.locale?.languageCode == 'ar' ? 100.r : 0,
                        ),
                      ),
            ),
            child: Text(
              tabs[index].tr,
              style: AppTextStyles.heading4().copyWith(
                fontSize: 7.sp,
                color:
                    isSelected
                        ? MyColors.white
                        : MyColors.white.withValues(alpha: 0.55),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }),
    );
  }

  // ─── Clues Tab ─────────────────────────────────────────────────────────────

  Widget _buildCluesTab(EvidenceController evidenceController) {
    if (evidenceController.isLoading.value) {
      return Center(
        child: CircularProgressIndicator(color: MyColors.redButtonColor),
      );
    }

    final evidence = selectedEvidence.value;
    if (evidence == null) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(MyImages.mail),
                height:
                    0.2.sh, // Limit the height of the image to prevent overflow
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20.h),
              Text(
                'No evidence available'.tr,
                style: AppTextStyles.heading1().copyWith(
                  fontSize: 10.sp,
                  color: MyColors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personal Information Fields
                    _buildInfoField(
                      'Clue Name:',
                      evidence.evidenceName ??
                          evidence.evidenceNameAr ??
                          'Unknown',
                    ),
                    SizedBox(height: 6.h),
                    _buildInfoField(
                      'Discovery Date:',
                      evidence.createdAt != null
                          ? DateFormat(
                            'dd MMM yyyy',
                          ).format(evidence.createdAt!)
                          : 'N/A',
                    ),

                    SizedBox(height: 12.h),

                    // Descriptive Paragraph
                    Text(
                      evidence.description ??
                          evidence.descriptionAr ??
                          'No biography available',
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
        ],
      ),
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
        Expanded(
          child: Text(
            ' $value',
            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
  // ─── Attachments Tab ───────────────────────────────────────────────────────

  Widget _buildAttachmentsTab(EvidenceController evidenceController) {
    return Obx(() {
      final type = selectedAttachmentType.value;
      if (type == null) return _buildAttachmentsGrid();
      if (type == 'Videos') return _buildVideosList(evidenceController);
      if (type == 'Images') return _buildImagesList(evidenceController);
      if (type == 'Documents') return _buildDocumentsList(evidenceController);
      if (type == 'Audio') return _buildAudioList(evidenceController);
      return _buildAttachmentsGrid();
    });
  }

  Widget _buildAttachmentsGrid() {
    final items = [
      {'icon': MyIcons.videos, 'label': 'Videos', 'type': 'Videos'},
      {'icon': MyIcons.gallery, 'label': 'Images', 'type': 'Images'},
      {'icon': MyIcons.document, 'label': 'Documents', 'type': 'Documents'},
      {'icon': MyIcons.audios, 'label': 'Audio', 'type': 'Audio'},
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => selectedAttachmentType.value = item['type'] as String,
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
    );
  }

  Widget _buildMediaContainer({
    required String icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: MyColors.BlueColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, height: 10.sp),
              SizedBox(width: 5.w),
              Text(
                title.tr,
                style: AppTextStyles.heading2().copyWith(
                  fontSize: 8.sp,
                  color: MyColors.white,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => selectedAttachmentType.value = null,
                child: SvgPicture.asset(MyIcons.arrowbackNoBackground),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Divider(color: Colors.white.withValues(alpha: 0.1)),
          SizedBox(height: 5.h),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) => Center(
    child: Text(
      message,
      style: AppTextStyles.heading1().copyWith(
        fontSize: 6.sp,
        color: MyColors.white.withValues(alpha: 0.5),
      ),
    ),
  );

  Widget _buildVideosList(EvidenceController c) {
    final List<dynamic> attachments = selectedEvidence.value?.attachments ?? [];
    final all =
        attachments
            .where((a) => a.attachmentType?.toLowerCase() == 'video')
            .toList();
    return _buildMediaContainer(
      icon: MyIcons.videos,
      title: 'Videos',
      child:
          all.isEmpty
              ? _buildEmptyState('No videos available'.tr)
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: all.length,
                itemBuilder: (context, index) {
                  final v = all[index];
                  return GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => VideoPlayerScreen(
                                  videoUrl: v.mediaUrl ?? '',
                                ),
                          ),
                        ),
                    child: Container(
                      width: 60.w,
                      margin: EdgeInsets.only(right: 10.w),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child:
                                (v.thumbnailUrl ?? '').isNotEmpty
                                    ? CachedNetworkImage(
                                      imageUrl: v.thumbnailUrl!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (_, __) => Container(
                                            color: MyColors.darkBlueColor,
                                          ),
                                      errorWidget:
                                          (_, __, ___) => Container(
                                            color: MyColors.darkBlueColor,
                                          ),
                                    )
                                    : Container(
                                      color: MyColors.darkBlueColor,
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        color: MyColors.white,
                                        size: 30.sp,
                                      ),
                                    ),
                          ),
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
    );
  }

  Widget _buildImagesList(EvidenceController c) {
    final List<dynamic> attachments = selectedEvidence.value?.attachments ?? [];
    final all =
        attachments
            .where((a) => a.attachmentType?.toLowerCase() == 'image')
            .toList();
    return _buildMediaContainer(
      icon: MyIcons.gallery,
      title: 'Images',
      child:
          all.isEmpty
              ? _buildEmptyState('No images available'.tr)
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: all.length,
                itemBuilder: (context, index) {
                  final img = all[index];
                  return GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ImagePreviewScreen(
                                  imageUrl: img.mediaUrl ?? '',
                                ),
                          ),
                        ),
                    child: Container(
                      width: 60.w,
                      margin: EdgeInsets.only(right: 10.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CachedNetworkImage(
                          imageUrl: img.mediaUrl ?? 'https://picsum.photos/200',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          placeholder:
                              (_, __) =>
                                  Container(color: MyColors.darkBlueColor),
                          errorWidget:
                              (_, __, ___) => Container(
                                color: MyColors.darkBlueColor,
                                child: Icon(Icons.error, color: MyColors.white),
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildDocumentsList(EvidenceController c) {
    final List<dynamic> attachments = selectedEvidence.value?.attachments ?? [];
    final all =
        attachments
            .where((a) => a.attachmentType?.toLowerCase() == 'document')
            .toList();
    return _buildMediaContainer(
      icon: MyIcons.document,
      title: 'Documents',
      child:
          all.isEmpty
              ? _buildEmptyState('No documents available'.tr)
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: all.length,
                itemBuilder: (context, index) {
                  final doc = all[index];
                  return GestureDetector(
                    onTap: () {
                      if (doc.mediaUrl?.isNotEmpty ?? false)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => PDFViewerScreen(pdfUrl: doc.mediaUrl!),
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
                              doc.attachmentNameEn ??
                                  doc.attachmentNameAr ??
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
    );
  }

  Widget _buildAudioList(EvidenceController c) {
    final List<dynamic> attachments = selectedEvidence.value?.attachments ?? [];
    final all =
        attachments
            .where((a) => a.attachmentType?.toLowerCase() == 'audio')
            .toList();
    return _buildMediaContainer(
      icon: MyIcons.audios,
      title: 'Audio',
      child:
          all.isEmpty
              ? _buildEmptyState('No audio files available'.tr)
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: all.length,
                itemBuilder: (context, index) {
                  final audio = all[index];
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
                            audio.attachmentNameAr ??
                            'Audio ${index + 1}',
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildEnvelopeGrid(EvidenceController evidenceController) {
    return Column(
      children: [
        // "New Clue has been revealed." text
        Text(
          'New Clue has been revealed.'.tr,
          style: AppTextStyles.heading1().copyWith(
            fontSize: 8.sp,
            color: MyColors.redButtonColor,
          ),
        ),
        SizedBox(height: 10.h),
        // Envelopes grid
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Obx(() {
              if (evidenceController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: MyColors.redButtonColor,
                  ),
                );
              }

              if (evidenceController.evidences.isEmpty) {
                return Center(
                  child: Text(
                    'No evidence available'.tr,
                    style: AppTextStyles.heading1().copyWith(
                      fontSize: 10.sp,
                      color: MyColors.white,
                    ),
                  ),
                );
              }

              return Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate item width based on 4 columns and 20.w spacing
                    final double itemWidth = (constraints.maxWidth - (3 * 20.w)) / 4;
                    
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20.w,
                        runSpacing: 20.h,
                        children: List.generate(
                          evidenceController.evidences.length,
                          (index) {
                            final evidence = evidenceController.evidences[index];

                            return SizedBox(
                              width: itemWidth,
                              height: itemWidth / 0.9, // match childAspectRatio: 0.9
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      MyImages.mail,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  GestureDetector(
                                    onTap: () {
                                      selectedEvidence.value = evidence;
                                      selectedTab.value = 0;
                                      selectedAttachmentType.value = null;
                                      showGrid.value = false;
                                    },
                                    child: Container(
                                      width: 80.w,
                                      padding: EdgeInsets.symmetric(vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color: MyColors.black.withValues(alpha: 0.4),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'View'.tr,
                                        style: AppTextStyles.heading2().copyWith(
                                          fontSize: 7.sp,
                                          color: MyColors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    evidence.evidenceName ??
                                        evidence.evidenceNameAr ??
                                        'Unknown Clue'.tr,
                                    style: AppTextStyles.heading2().copyWith(
                                      fontSize: 5.sp, // Small font size
                                      color: MyColors.white.withValues(alpha: 0.8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
