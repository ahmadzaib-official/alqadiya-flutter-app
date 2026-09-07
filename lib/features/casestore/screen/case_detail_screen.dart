import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/services/auth_guard.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/auth/controller/user_controller.dart';
import 'package:alqadiya_game/features/casestore/controller/add_case_controller.dart';
import 'package:alqadiya_game/widgets/case_detail_shimmer.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/start_play_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';

class CaseDetailScreen extends StatefulWidget {
  const CaseDetailScreen({super.key});
  // final String gameId;
  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  final gameId = Get.arguments['gameId'] ?? '';
  final GameController controller = Get.find<GameController>();
  bool isStartingGame = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getGameDetail(gameId: gameId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Obx(() {
        final isPurchased = controller.gameDetail.value.isPurchased ?? false;
        final gameId = controller.gameDetail.value.id ?? '';

        return GameBackground(
          isPurchased: isPurchased,
          imageUrl: controller.gameDetail.value.coverImageUrl ?? "",
          body: Column(
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 5.sp),
                child: HomeHeader(
                  title: Text(
                    controller.gameDetail.value.title ?? "",
                    style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                  ),
                  actionButtons: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(MyIcons.arrowbackrounded),
                  ),
                ),
              ),
              // Body
              if ((controller.isLoading.value && !isStartingGame) ||
                  (controller.gameDetail.value.id != null &&
                      controller.gameDetail.value.id != this.gameId)) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: CaseDetailShimmer(),
                ),
              ] else if (controller.gameDetail.value.id == null) ...[
                Center(
                  child: Text(
                    'Failed to get case details...'.tr,
                    style: AppTextStyles.bodyTextRegular16().copyWith(
                      color: MyColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Case Image and Details Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Right Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Difficulty and Duration Row
                                    Row(
                                      children: [
                                        // Difficulty Badge
                                        SvgPicture.asset(
                                          MyIcons.difficultyGuage,
                                          width: 10.sp,
                                          height: 10.sp,
                                        ),
                                        SizedBox(width: 3.w),
                                        Text(
                                          'Difficulty'.tr,
                                          style: AppTextStyles.labelMedium14()
                                              .copyWith(
                                                fontSize: 6.sp,
                                                color: MyColors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: MyColors.brightRedColor,

                                            borderRadius: BorderRadius.circular(
                                              100.r,
                                            ),
                                          ),
                                          child: Text(
                                            "${controller.gameDetail.value.difficulty?.tr ?? 'Intermediate'}",
                                            style: AppTextStyles.labelMedium14()
                                                .copyWith(
                                                  fontSize: 6.sp,
                                                  color: MyColors.white,
                                                ),
                                          ),
                                        ),
                                        SizedBox(width: 5.sp),
                                        Container(
                                          width: 1.w,
                                          height: 20.h,
                                          color: MyColors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                        SizedBox(width: 5.sp),

                                        // Duration
                                        SvgPicture.asset(
                                          MyIcons.clock,
                                          width: 10.sp,
                                          height: 10.sp,
                                        ),
                                        SizedBox(width: 3.w),
                                        Text(
                                          'Duration'.tr,
                                          style: AppTextStyles.labelMedium14()
                                              .copyWith(
                                                fontSize: 6.sp,
                                                color: MyColors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: MyColors.black.withValues(
                                              alpha: 0.2,
                                            ),

                                            borderRadius: BorderRadius.circular(
                                              100.r,
                                            ),
                                          ),
                                          child: Text(
                                            "${controller.gameDetail.value.estimatedDuration ?? '40'} ${'minutes'.tr}",
                                            style: AppTextStyles.labelMedium14()
                                                .copyWith(
                                                  fontSize: 6.sp,
                                                  color: MyColors.white,
                                                ),
                                          ),
                                        ),
                                        Spacer(),
                                        if (isPurchased) ...[
                                          StartPlayButton(
                                            buttonWidth: 50.w,
                                            buttonText: 'Start Play'.tr,
                                            onTap:
                                                isStartingGame
                                                    ? () {}
                                                    : () async {
                                                      setState(() {
                                                        isStartingGame = true;
                                                      });

                                                      await controller
                                                          .createGameSession(
                                                            gameId: gameId,
                                                          );

                                                      // Reset state after navigation
                                                      if (mounted) {
                                                        setState(() {
                                                          isStartingGame =
                                                              false;
                                                        });
                                                      }
                                                    },
                                          ),
                                        ] else ...[
                                          GestureDetector(
                                            onTap: () {
                                              AuthGuard.executeIfAuthenticated(
                                                title: 'Purchase Case'.tr,
                                                message:
                                                    'Please sign in to purchase this case'
                                                        .tr,
                                                action: () {
                                                  final userController =
                                                      Get.find<
                                                        UserController
                                                      >();
                                                  final userPoints =
                                                      userController
                                                          .user
                                                          .value
                                                          ?.pointsBalance ??
                                                      0;
                                                  final cost =
                                                      controller
                                                          .gameDetail
                                                          .value
                                                          .costPoints ??
                                                      0;

                                                  if (userPoints == 0 ||
                                                      userPoints < cost) {
                                                    Get.toNamed(
                                                      AppRoutes.buyPointsScreen,
                                                    );
                                                  } else {
                                                    final addCaseController =
                                                        Get.put(
                                                          AddCaseController(),
                                                        );
                                                    addCaseController
                                                        .game
                                                        .value = controller
                                                            .gameDetail
                                                            .value;
                                                    addCaseController
                                                        .handleAddCaseWithAuth(
                                                          gameId: gameId,
                                                        );
                                                  }
                                                },
                                              );
                                            },
                                            child: Container(
                                              width: 60.w,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: MyColors.redButtonColor,
                                              ),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Spacer(flex: 6),
                                                  Text(
                                                    'Buy'.tr,
                                                    style: TextStyle(
                                                      fontSize: 6.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Container(
                                                    width: 1,
                                                    height: 18.h,
                                                    color:
                                                        MyColors.brightRedColor,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    '${controller.gameDetail.value.costPoints ?? 0} ',
                                                    style: TextStyle(
                                                      fontSize: 6.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Points'.tr,
                                                    style: TextStyle(
                                                      fontSize: 6.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Spacer(flex: 2),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 8.sp,
                                                    color:
                                                        MyColors.brightRedColor,
                                                  ),
                                                  Spacer(flex: 1),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 20.h),
                                    // Description Text
                                    Text(
                                      controller.gameDetail.value.description ??
                                          "",
                                      style: AppTextStyles.captionRegular12()
                                          .copyWith(
                                            color: MyColors.white,
                                            height: 1.5,
                                            fontSize: 6.sp,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
