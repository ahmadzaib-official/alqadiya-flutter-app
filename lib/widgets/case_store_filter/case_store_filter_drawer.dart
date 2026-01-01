import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CaseStoreFilterDrawer extends StatelessWidget {
  final VoidCallback onCloseTap;
  final VoidCallback onApplyTap;
  final VoidCallback onCancelTap;

  const CaseStoreFilterDrawer({
    Key? key,
    required this.onCloseTap,
    required this.onApplyTap,
    required this.onCancelTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();

    return Container(
      width: MediaQuery.sizeOf(context).width * 0.4,
      height: MediaQuery.sizeOf(context).height,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: MyColors.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(-10, 0),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Filters title and Reset button
            Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: MyColors.black.withValues(alpha: 0.2),
                        radius: 20.r,
                        child: SvgPicture.asset(
                          MyIcons.filterOutline,
                          width: 18.w,
                          height: 18.h,
                          colorFilter: ColorFilter.mode(
                            MyColors.brightRedColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        'Filters'.tr,
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.resetFilters();
                    },
                    child: Text(
                      'Reset'.tr,
                      style: AppTextStyles.labelMedium14().copyWith(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.bold,
                        color: MyColors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: MyColors.white.withValues(alpha: 0.1), height: 1.h),

            // Difficulty Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        MyIcons.difficultyGuage,
                        width: 25.w,
                        height: 25.h,
                        colorFilter: ColorFilter.mode(
                          MyColors.white.withValues(alpha: 0.7),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Difficulty'.tr,
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Obx(
                  //   () => Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children:
                  //         controller.difficulties.map((difficulty) {
                  //           final isSelected =
                  //               controller.selectedDifficulty.value ==
                  //               difficulty;
                  //           return GestureDetector(
                  //             onTap: () => controller.setDifficulty(difficulty),
                  //             child: Container(
                  //               margin: EdgeInsets.only(right: 4.sp),
                  //               padding: EdgeInsets.symmetric(
                  //                 horizontal: 5.w,
                  //                 vertical: 5.h,
                  //               ),
                  //               decoration: BoxDecoration(
                  //                 color:
                  //                     isSelected
                  //                         ? MyColors.brightRedColor
                  //                         : MyColors.black.withValues(
                  //                           alpha: 0.2,
                  //                         ),
                  //                 borderRadius: BorderRadius.circular(100.r),
                  //               ),
                  //               child: Text(
                  //                 difficulty,
                  //                 style: AppTextStyles.labelMedium14().copyWith(
                  //                   fontSize: 7.sp,
                  //                   color:
                  //                       isSelected
                  //                           ? MyColors.white
                  //                           : MyColors.white.withValues(
                  //                             alpha: 0.5,
                  //                           ),
                  //                 ),
                  //               ),
                  //             ),
                  //           );
                  //         }).toList(),
                  //   ),
                  // ),
                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            controller.difficulties.map((difficulty) {
                              final isSelected =
                                  controller.selectedDifficulty.value ==
                                  difficulty;

                              return GestureDetector(
                                onTap:
                                    () => controller.setDifficulty(difficulty),
                                child: Container(
                                  margin: EdgeInsets.only(right: 2.sp),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? MyColors.brightRedColor
                                            : MyColors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  child: Text(
                                    difficulty,
                                    style: AppTextStyles.labelMedium14()
                                        .copyWith(
                                          fontSize: 7.sp,
                                          color:
                                              isSelected
                                                  ? MyColors.white
                                                  : MyColors.white.withValues(
                                                    alpha: 0.5,
                                                  ),
                                        ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider(color: MyColors.white.withValues(alpha: 0.1), height: 1),

            // Points Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        MyIcons.coins,
                        width: 25.w,
                        height: 25.h,
                        colorFilter: ColorFilter.mode(
                          MyColors.white.withValues(alpha: 0.5),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Points'.tr,
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: MyColors.black.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 4.h,
                              ),
                              child: Text(
                                '${controller.minPoints.value.toInt()}',
                                style: AppTextStyles.labelMedium14().copyWith(
                                  fontSize: 6.sp,
                                  color: MyColors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: MyColors.black.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 2.h,
                              ),
                              child: Text(
                                '${controller.maxPoints.value.toInt()} Points',
                                style: AppTextStyles.labelMedium14().copyWith(
                                  fontSize: 6.sp,
                                  color: MyColors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 3.h),
                        SizedBox(
                          // width: 80.w,
                          child: RangeSlider(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              // horizontal: 25.w,
                            ),
                            values: RangeValues(
                              controller.minPoints.value,
                              controller.maxPoints.value,
                            ),
                            min: 0,
                            max: 100,
                            onChanged: (RangeValues values) {
                              controller.setPointsRange(
                                values.start,
                                values.end,
                              );
                            },
                            activeColor: MyColors.redButtonColor,
                            inactiveColor: MyColors.black.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // Apply Button
            CustomButton(
              height: 50.h,
              fontSize: 6.sp,
              text: 'Apply',
              onPressed: () {
                controller.applyFilters();
                onApplyTap();
              },
            ),
            SizedBox(height: 15.h),
            // Cancel Button
            CustomOutlineButton(
              height: 50.h,
              fontSize: 6.sp,
              text: 'Cancel'.tr,
              onPressed: onCancelTap,
              textColor: MyColors.white.withValues(alpha: 0.5),
              outlineColor: MyColors.white.withValues(alpha: 0.1),
            ),
          ],
        ),
      ),
    );
  }
}
