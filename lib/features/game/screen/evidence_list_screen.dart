import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/controller/evidence_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_timer_controller.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/game_footer.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alqadiya_game/core/utils/localization_helper.dart';
import 'package:get/get.dart';

class EvidenceListScreen extends StatefulWidget {
  const EvidenceListScreen({super.key});

  @override
  State<EvidenceListScreen> createState() => _EvidenceListScreenState();
}

class _EvidenceListScreenState extends State<EvidenceListScreen> {
  late final GameTimerController timerController;
  final evidenceController = Get.find<EvidenceController>();
  final gameController = Get.find<GameController>();

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<GameTimerController>()) {
      timerController = Get.find<GameTimerController>();
    } else {
      timerController = Get.put(GameTimerController(), permanent: true);
      timerController.startTimer();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameId =
          gameController.gameDetail.value.id ??
          gameController.gameSession.value?.gameId;
      if (gameId != null) {
        evidenceController.getEvidencesByGame(gameId: gameId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context);
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
                        Text(
                          'List of evidence'.tr,
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(MyIcons.arrowbackrounded),
                    ),
                  ),
                ),

                SizedBox(height: 5.h),

                // ── Main Content ─────────────────────────────────────────────
                Expanded(
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
                            fontSize: 8.sp,
                            color: MyColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    }

                    final evidences = evidenceController.evidences.toList();

                    return Center(
                      child: SizedBox(
                        height: 0.5.sh, // enough to fit image + name
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: evidences.length,
                          itemBuilder: (context, index) {
                            final evidence = evidences[index];
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.clueDetailScreen,
                                  arguments: {'evidenceId': evidence.id},
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Evidence Image
                                    Container(
                                      width: 50.w,
                                      height: 60.w,
                                      decoration: BoxDecoration(
                                        color: MyColors.white,
                                        borderRadius: BorderRadius.circular(10.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              evidence.profileImageURL ??
                                              evidence.profileImage ??
                                              'https://picsum.photos/200',
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => Container(
                                                color: MyColors.darkBlueColor,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color:
                                                            MyColors
                                                                .redButtonColor,
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  Container(
                                                    color: MyColors.white,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.file_present_rounded,
                                                        color: MyColors.BlueColor,
                                                        size: 40.sp,
                                                      ),
                                                    ),
                                                  ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    // Evidence Name
                                    SizedBox(
                                      width: 50.w,
                                      child: Text(
                                        LocalizedStringFallback.getLocalizedValue(
                                                evidence.evidenceName,
                                                evidence.evidenceNameAr,
                                              ).isNotEmpty
                                              ? LocalizedStringFallback
                                                  .getLocalizedValue(
                                                evidence.evidenceName,
                                                evidence.evidenceNameAr,
                                              )
                                              : 'Unknown Clue'.tr,
                                        style: TextStyle(
                                          fontSize: 6.sp,
                                          color: MyColors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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
}
