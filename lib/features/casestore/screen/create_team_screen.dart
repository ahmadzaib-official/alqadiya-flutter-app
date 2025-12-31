import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/widgets/custom_textfield.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/start_play_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';

class CreateTeamScreen extends StatefulWidget {
  CreateTeamScreen({super.key});
  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final TextEditingController firstTeamNameController = TextEditingController();
  final TextEditingController secondTeamNameController =
      TextEditingController();

  @override
  void dispose() {
    firstTeamNameController.dispose();
    secondTeamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        isPurchased: true,
        imageUrl: "https://picsum.photos/200",
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
                      'Who did it?'.tr,
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
                      'Create teams'.tr,
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Case Image
                  Container(
                    height: 0.45.sh,
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: MyColors.black.withValues(alpha: 0.1),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'First Team'.tr,
                          style: AppTextStyles.heading1().copyWith(
                            fontSize: 8.sp,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        CustomTextfield(
                          width: 0.25.sw,
                          fieldTextSize: 7,
                          hintFontSize: 7,
                          horizentalContentPadding: 2,
                          labelVisible: false,
                          maxLines: 1,
                          label: 'Name of the team'.tr,
                          hintText: 'Name of the team'.tr,
                          borderColor: MyColors.white,
                          color: MyColors.white.withValues(alpha: 0.1),
                          controller: firstTeamNameController,
                          suffix: Icon(Icons.people_outline),
                          keyboardType: TextInputType.name,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Right Content
                  Container(
                    height: 0.45.sh,
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: MyColors.black.withValues(alpha: 0.1),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          'Second Team'.tr,
                          style: AppTextStyles.heading1().copyWith(
                            fontSize: 8.sp,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        CustomTextfield(
                          width: 0.25.sw,
                          fieldTextSize: 7,
                          hintFontSize: 7,
                          maxLines: 1,
                          horizentalContentPadding: 2,
                          labelVisible: false,
                          label: 'Name of the team'.tr,
                          hintText: 'Name of the team'.tr,
                          borderColor: MyColors.white,
                          color: MyColors.white.withValues(alpha: 0.1),
                          controller: secondTeamNameController,
                          suffix: Icon(Icons.people_outline),
                          keyboardType: TextInputType.name,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  StartPlayButton(
                    buttonWidth: 50.w,
                    buttonText: 'Next'.tr,
                    onTap: () {
                      if (firstTeamNameController.text.isNotEmpty &&
                          secondTeamNameController.text.isNotEmpty) {
                        Get.find<GameController>().createTeams(
                          firstTeamName: firstTeamNameController.text,
                          secondTeamName: secondTeamNameController.text,
                        );
                      } else {
                        CustomSnackbar.show(
                          message: 'Please enter both team names'.tr,
                          backgroundColor: MyColors.redButtonColor,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
