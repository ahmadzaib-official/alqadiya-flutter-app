import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/casestore/controller/choose_team_leader_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/start_play_button.dart';
import 'package:alqadiya_game/widgets/team_leader_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';

class ChooseTeamLeaderScreen extends StatelessWidget {
  ChooseTeamLeaderScreen({super.key});

  final ChooseTeamLeaderController controller =
      Get.find<ChooseTeamLeaderController>();
  final gameController = Get.find<GameController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Top Bar
              Padding(
                padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 5.sp),
                child: HomeHeader(
                  onChromTap: () {},
                  title: Row(
                    children: [
                      Text(
                        gameController.gameDetail.value.title ??
                            'Who did it?'.tr,
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 10.sp,
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
                        'Choosing a leader'.tr,
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 7.sp,
                          color: MyColors.white.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w100,
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

              SizedBox(height: 20.h),
              // Body - Team Leader Selection
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 1, child: SizedBox()),
                    // Team Info and Members Section
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: MyColors.black.withValues(alpha: 0.1),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title and Refresh Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Text(
                                    controller.teamName.value.isEmpty
                                        ? 'Team Da7i7'.tr
                                        : controller.teamName.value,
                                    style: AppTextStyles.heading1().copyWith(
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),

                            // Subtitle
                            Text(
                              'Choose a leader for your team'.tr,
                              style: AppTextStyles.captionRegular12().copyWith(
                                color: MyColors.white,
                                height: 1.5,
                                fontSize: 7.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20.h),
                            // Leaders Grid
                            Obx(
                              () =>
                                  controller.teamLeaders.isEmpty
                                      ? Padding(
                                        padding: EdgeInsets.all(20.h),
                                        child: Text(
                                          'No team members available'.tr,
                                          style:
                                              AppTextStyles.captionRegular12()
                                                  .copyWith(
                                                    color: MyColors.white
                                                        .withValues(alpha: 0.5),
                                                    fontSize: 6.sp,
                                                  ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                      : Wrap(
                                        spacing: 5.w,
                                        runSpacing: 10.h,
                                        alignment: WrapAlignment.center,
                                        children:
                                            controller.teamLeaders
                                                .map(
                                                  (leader) => TeamLeaderCard(
                                                    name: leader.name,
                                                    imageUrl: leader.imageUrl,
                                                    isSelected: controller
                                                        .isLeaderSelected(
                                                          leader.id,
                                                        ),
                                                    onTap:
                                                        () => controller
                                                            .selectLeader(
                                                              leader,
                                                            ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Next Button
                    Obx(
                      () => Opacity(
                        opacity: controller.isLoading.value ? 0.6 : 1.0,
                        child: StartPlayButton(
                          buttonWidth: 50.w,
                          buttonText: 'Next'.tr,
                          onTap:
                              controller.isLoading.value
                                  ? () {}
                                  : () =>
                                      controller.proceedWithSelectedLeader(),
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
