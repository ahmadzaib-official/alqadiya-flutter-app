import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/widgets/case_detail_shimmer.dart';
import 'package:alqadiya_game/widgets/copy_code_button.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/start_play_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:shimmer/shimmer.dart';

class CaseDetailScreen extends StatefulWidget {
  const CaseDetailScreen({super.key});
  // final String gameId;
  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  final gameId = Get.arguments['gameId'] ?? '';
  final GameController controller = Get.find<GameController>();
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
                  onChromTap: () {},
                  title: Text(
                    controller.gameDetail.value.title ?? "",
                    style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                  ),
                  actionButtons: GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset(MyIcons.arrowbackrounded),
                  ),
                ),
              ),
              // Body
              if (controller.isLoading.value &&
                  controller.gameDetail.value.isBlank!) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: CaseDetailShimmer(),
                ),
              ] else if (!controller.isLoading.value &&
                  controller.gameDetail.value.isBlank!) ...[
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Case Image and Details Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Case Image
                              Column(
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          16.sp,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              controller
                                                  .gameDetail
                                                  .value
                                                  .coverImageUrl ??
                                              '',
                                          width: isPurchased ? 0.2.sw : 0.18.sw,
                                          height:
                                              isPurchased ? 0.45.sh : 0.65.sh,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) =>
                                                  Shimmer.fromColors(
                                                    baseColor: MyColors
                                                        .backgroundColor
                                                        .withValues(alpha: 0.3),
                                                    highlightColor: MyColors
                                                        .white
                                                        .withValues(alpha: 0.1),
                                                    child: Container(
                                                      width:
                                                          isPurchased
                                                              ? 0.2.sw
                                                              : 0.18.sw,
                                                      height:
                                                          isPurchased
                                                              ? 0.45.sh
                                                              : 0.65.sh,
                                                      color: Colors.grey,
                                                    ),
                                                  ),

                                          // ❌ Error widget
                                          errorWidget:
                                              (context, url, error) =>
                                                  Container(
                                                    width:
                                                        isPurchased
                                                            ? 0.2.sw
                                                            : 0.18.sw,
                                                    height:
                                                        isPurchased
                                                            ? 0.45.sh
                                                            : 0.65.sh,
                                                    color: Colors.grey.shade200,
                                                    alignment: Alignment.center,
                                                    child: const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                      size: 40,
                                                    ),
                                                  ),
                                        ),
                                      ),

                                      if (!isPurchased)
                                        Positioned(
                                          right: 10.h,
                                          top: 40.h,
                                          child: SvgPicture.asset(
                                            MyIcons.lockrounded,
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (isPurchased && gameId.isNotEmpty) ...[
                                    SizedBox(height: 8.h),
                                    CopyCodeButton(code: gameId),

                                    SizedBox(height: 10.h),

                                    Text(
                                      'Share this code with friends to join.'.tr,
                                      style: AppTextStyles.captionRegular12()
                                          .copyWith(
                                            color: MyColors.white,
                                            height: 1.5,
                                            fontSize: 5.sp,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(width: 12.w),

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
                                            "${controller.gameDetail.value.difficulty ?? 'Intermediate'}",
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
                                            onTap: () {
                                              controller.createGameSession(
                                                gameId: gameId,
                                              );
                                            },
                                          ),
                                        ] else ...[
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                AppRoutes.addCaseScreen,
                                                arguments: {
                                                  'game': controller.gameDetail,
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
