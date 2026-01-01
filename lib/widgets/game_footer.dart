import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/controller/game_footer_controller.dart';
import 'package:alqadiya_game/widgets/custom_icon_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

/// Game footer widget with game-related action buttons
class GameFooter extends StatelessWidget {
  const GameFooter({
    super.key,
    this.showDivider = true,
    required this.onGameResultTap,
    this.isResultCompleted = false,
  });
  final bool showDivider;
  final VoidCallback onGameResultTap;
  final bool isResultCompleted;

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already registered
    if (!Get.isRegistered<GameFooterController>()) {
      Get.put(GameFooterController(), permanent: true);
    }
    final footerController = Get.find<GameFooterController>();

    return Column(
      children: [
        if (showDivider) ...[
          SizedBox(height: 5.h),
          Divider(color: MyColors.white.withValues(alpha: 0.1)),
        ],
        Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconTextButton(
                height: 55.h,
                buttonText: 'Team score'.tr,
                icon: MyIcons.arrowbackrounded,
                isTextButton: true,
                scoreValue: footerController.totalScore.value,
                onTap: () {},
              ),
              CustomIconTextButton(
                height: 55.h,
                forgroundColor: isResultCompleted ? MyColors.white : null,
                buttonColor: isResultCompleted ? MyColors.redButtonColor : null,
                buttonText: 'Game Result'.tr,
                icon: MyIcons.dice,
                isIconButton: true,
                onTap: onGameResultTap,
              ),
              CustomIconTextButton(
                height: 55.h,
                width: 70.w,
                buttonText: 'Progress'.tr,
                isProgressButton: true,
                progressValue: footerController.progress,
                icon: MyIcons.arrowbackrounded,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
