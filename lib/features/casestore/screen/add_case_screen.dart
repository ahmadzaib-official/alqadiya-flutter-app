import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/casestore/controller/add_case_controller.dart';

class AddCaseScreen extends StatelessWidget {
  AddCaseScreen({super.key});

  final AddCaseController controller = Get.find<AddCaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        imageUrl: controller.game.value?.coverImageUrl ?? "",
        body: Obx(() {
          if (controller.game.value == null) {
            return Center(child: CircularProgressIndicator());
          }
          final game = controller.game.value!;
          return Column(
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 5.sp),
                child: HomeHeader(
                  onChromTap: () {},
                  title: Text(
                    'Add the case'.tr,
                    style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                  ),
                  actionButtons: GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset(MyIcons.arrowbackrounded),
                  ),
                ),
              ),
              // Body
              Expanded(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Case Image
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Request Summary'.tr,
                                  style: AppTextStyles.heading1().copyWith(
                                    fontSize: 8.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(height: 40.h),

                            Container(
                              width: 0.28.sw,
                              height: 0.2.sh,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    game.coverImageUrl ?? "",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 25.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 0.05.sw,
                                  child: Text(
                                    'Game'.tr,
                                    style: AppTextStyles.heading2().copyWith(
                                      fontSize: 7.sp,
                                      // fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.w),

                                Container(
                                  width: 1.w,
                                  height: 20.h,
                                  color: MyColors.white.withValues(alpha: 0.2),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  game.title ?? "",
                                  style: AppTextStyles.heading1().copyWith(
                                    fontSize: 7.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 0.05.sw,

                                  child: Text(
                                    'Cost'.tr,
                                    style: AppTextStyles.heading2().copyWith(
                                      fontSize: 7.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.w),

                                Container(
                                  width: 1.w,
                                  height: 20.h,
                                  color: MyColors.white.withValues(alpha: 0.2),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  '${game.costPoints} '.tr,
                                  style: AppTextStyles.heading1().copyWith(
                                    fontSize: 8.sp,
                                  ),
                                ),
                                Text(
                                  'points'.tr,
                                  style: AppTextStyles.heading2().copyWith(
                                    fontSize: 7.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 10.w),
                        SizedBox(
                          height: 0.7.sh,
                          child: VerticalDivider(
                            color: MyColors.white.withValues(alpha: 0.2),
                            thickness: 1,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        // Right Content
                        Expanded(
                          child: Obx(
                            () => Column(
                              crossAxisAlignment:
                                  controller.isSuccessful.value
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.center,
                              mainAxisAlignment:
                                  controller.isSuccessful.value
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.center,
                              children: [
                                if (!controller.isSuccessful.value) ...[
                                  // Points available section (shown before success)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Points available in the balance'.tr,
                                        style: AppTextStyles.heading1()
                                            .copyWith(fontSize: 7.sp),
                                      ),
                                      SizedBox(width: 8.w),
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
                                          '200 Points',
                                          style:
                                              AppTextStyles.captionSemiBold10()
                                                  .copyWith(
                                                    fontSize: 7.sp,
                                                    color: MyColors.white,
                                                  ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30.h),
                                  // Add Case Button
                                  GestureDetector(
                                    onTap:
                                        controller.isAuthenticating.value
                                            ? null
                                            : () {
                                              controller.handleAddCaseWithAuth(
                                                gameId: game.id!,
                                              );
                                            },
                                    child: Container(
                                      width: 90.w,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color:
                                            controller.isAuthenticating.value
                                                ? MyColors.redButtonColor
                                                    .withValues(alpha: 0.5)
                                                : MyColors.redButtonColor,
                                      ),
                                      alignment: Alignment.center,
                                      child:
                                          controller.isAuthenticating.value
                                              ? CircularProgressIndicator(
                                                strokeWidth: 1,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(MyColors.brightRedColor),
                                              )
                                              : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${game.costPoints} ',
                                                    style: TextStyle(
                                                      fontSize: 7.sp,
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
                                                  SizedBox(width: 5.w),
                                                  Container(
                                                    width: 1.w,
                                                    height: 20.h,
                                                    color:
                                                        MyColors.brightRedColor,
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  Text(
                                                    'Add Case'.tr,
                                                    style: TextStyle(
                                                      fontSize: 6.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 8.sp,
                                                    color:
                                                        MyColors.brightRedColor,
                                                  ),
                                                ],
                                              ),
                                    ),
                                  ),
                                ] else ...[
                                  // Success State
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 20.h),

                                      Text(
                                        'Successfully Added'.tr,
                                        style: AppTextStyles.heading1()
                                            .copyWith(fontSize: 8.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8.h),
                                      // Success Description
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                        ),
                                        child: Text(
                                          'The case has been added successfully'
                                              .tr,
                                          style:
                                              AppTextStyles.bodyTextRegular16()
                                                  .copyWith(
                                                    fontSize: 8.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: MyColors.white
                                                        .withValues(alpha: 0.7),
                                                  ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),

                                      // Success Icon
                                      Stack(
                                        children: [
                                          SvgPicture.asset(
                                            MyIcons.fingerprint,
                                            height: 130.h,
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 10,
                                            child: SvgPicture.asset(
                                              MyIcons.check,
                                              height: 40.h,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Success Title
                                      SizedBox(height: 20.h),
                                      // Enter Game Button
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 40.w,
                                        ),
                                        child: CustomButton(
                                          fontSize: 6.sp,
                                          text: 'Enter the game'.tr,
                                          onPressed: () async {
                                            final GameController controller =
                                                Get.find<GameController>();
                                            await controller.createGameSession(
                                              gameId: game.id ?? '',
                                            );
                                          },
                                          backgroundColor: MyColors.white
                                              .withValues(alpha: 0.05),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
