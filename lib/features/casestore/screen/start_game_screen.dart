import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/copy_code_button.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/start_play_button.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';

class StartGameScreen extends StatefulWidget {
  StartGameScreen({super.key});
  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  final controller = Get.find<GameController>();

  @override
  void initState() {
    super.initState();
    // Session code will be fetched from gameSession
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Obx(
        () => GameBackground(
          isPurchased: true,
          imageUrl: controller.gameDetail.value?.coverImageUrl ?? 
                   controller.gameDetail.value?.coverImage ?? 
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
                        controller.gameDetail.value?.title ?? 'Who did it?'.tr,
                        style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                      ),
                    SizedBox(width: 5.w),
                    Container(
                      width: 1.w,
                      height: 20.h,
                      color: MyColors.white.withValues(alpha: 0.2),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Start the Game'.tr,
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
            // Body
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Case Image
                Container(
                  height: 0.7.sh,
                  width: 0.3.sw,
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: MyColors.black.withValues(alpha: 0.1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Create Teams'.tr,
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 8.sp,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Obx(
                        () => CopyCodeButton(
                          code: controller.gameSession.value?.sessionCode ?? '',
                          horizontalPadding: 14,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      Text(
                        'Share this code with friends to join.',
                        style: AppTextStyles.captionRegular12().copyWith(
                          color: MyColors.white,
                          height: 1.5,
                          fontSize: 5.sp,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.sp),
                        child: StartPlayButton(
                          buttonText: 'Start Play'.tr,
                          onTap: () {
                            controller.updateSessionMode(mode: 'team');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),

                // Right Content
                Container(
                  height: 0.7.sh,
                  width: 0.3.sw,
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: MyColors.black.withValues(alpha: 0.1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Play Solo'.tr,
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 8.sp,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.sp),
                        child: StartPlayButton(
                          buttonText: 'Start Play'.tr,
                          onTap: () {
                            controller.updateSessionMode(mode: 'solo');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
