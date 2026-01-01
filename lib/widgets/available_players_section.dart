import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/casestore/controller/player_selection_controller.dart';
import 'package:alqadiya_game/widgets/draggable_player_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AvailablePlayersSection extends StatelessWidget {
  final PlayerSelectionController controller;

  const AvailablePlayersSection({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Text(
            'Drag and drop players into teams.',
            style: AppTextStyles.captionRegular12().copyWith(
              color: MyColors.white,
              height: 1.5,
              fontSize: 6.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          // Available players horizontal scrollable list
          Expanded(
            child: Obx(
              () =>
                  controller.availablePlayers.isEmpty
                      ? Center(
                        child: Text(
                          'All players assigned'.tr,
                          style: AppTextStyles.captionRegular12().copyWith(
                            color: MyColors.white.withValues(alpha: 0.4),
                            fontSize: 6.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                      : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              controller.availablePlayers
                                  .map(
                                    (player) => Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1.w,
                                      ),
                                      child: DraggablePlayerCard(
                                        player: player,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
            ),
          ),
          SizedBox(height: 12.h),

          // Automatic shuffle button
          GestureDetector(
            onTap: () => controller.shufflePlayers(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: MyColors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(MyIcons.shuffle, width: 9.w, height: 9.w),
                  SizedBox(width: 4.w),
                  Text(
                    'Automatic player transfer'.tr,
                    style: AppTextStyles.captionRegular12().copyWith(
                      color: MyColors.black,
                      fontSize: 6.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
