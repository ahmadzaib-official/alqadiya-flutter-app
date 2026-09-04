import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/services/auth_guard.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/auth/controller/user_controller.dart';
import 'package:alqadiya_game/core/services/local_auth_service.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/case_store/widgets/case_detail_shimmer.dart';
import 'package:alqadiya_game/features/game/widgets/game_background.dart';
import 'package:alqadiya_game/core/widgets/home_header.dart';
import 'package:alqadiya_game/features/game/widgets/start_play_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';

class CaseDetailScreen extends StatefulWidget {
  const CaseDetailScreen({super.key});
  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  final gameId = Get.arguments['gameId'] ?? '';
  final GameController controller = Get.find<GameController>();
  late LocalAuthService _localAuthService;
  bool isStartingGame = false;
  bool isAuthenticating = false;

  @override
  void initState() {
    _localAuthService = LocalAuthService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getGameDetail(gameId: gameId);
    });
    super.initState();
  }

  Future<void> handlePurchase() async {
    final userController = Get.find<UserController>();
    final userPoints = userController.user.value?.pointsBalance ?? 0;
    final costPoints = controller.gameDetail.value.costPoints ?? 0;

    if (userPoints < costPoints) {
      Get.toNamed(AppRoutes.buyPointsScreen);
      return;
    }

    if (isAuthenticating) return;
    setState(() {
      isAuthenticating = true;
    });

    try {
      final isAuthenticated = await _localAuthService.authenticate(
        reason: 'Authenticate to purchase this case'.tr,
        useErrorDialogs: true,
      );

      if (isAuthenticated) {
        await controller.purchaseGame(gameId: gameId);
        // On success, isPurchased should automatically update via GetX if gameDetail is updated.
      }
    } catch (e) {
      Get.snackbar(
        'Authentication Failed'.tr,
        'Failed to authenticate. Please try again.'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      if (mounted) {
        setState(() {
          isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Obx(() {
        final isPurchased = controller.gameDetail.value.isPurchased ?? false;
        final currentGameId = controller.gameDetail.value.id ?? '';

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
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                                  gameId: currentGameId,
                                                );

                                            // Reset state after navigation
                                            if (mounted) {
                                              setState(() {
                                                isStartingGame = false;
                                              });
                                            }
                                          },
                                ),
                              ] else ...[
                                GestureDetector(
                                  onTap: isAuthenticating ? null : () {
                                    AuthGuard.executeIfAuthenticated(
                                      title: 'Purchase Case'.tr,
                                      message:
                                          'Please sign in to purchase this case'
                                              .tr,
                                      action: handlePurchase,
                                    );
                                  },
                                  child: Container(
                                    width: 70.w,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: isAuthenticating ? MyColors.redButtonColor.withValues(alpha: 0.5) : MyColors.redButtonColor,
                                    ),
                                    alignment: Alignment.center,
                                    child: isAuthenticating
                                        ? SizedBox(
                                            width: 10.sp,
                                            height: 10.sp,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: MyColors.white),
                                          )
                                        : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Spacer(flex: 6),
                                        Text(
                                          'Buy'.tr,
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 1,
                                          height: 18.h,
                                          color: MyColors.brightRedColor,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${controller.gameDetail.value.costPoints ?? 0} ',
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          'Points'.tr,
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Spacer(flex: 2),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 8.sp,
                                          color: MyColors.brightRedColor,
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
                            controller.gameDetail.value.description ?? "",
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
