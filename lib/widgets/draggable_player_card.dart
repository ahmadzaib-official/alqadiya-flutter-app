import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/casestore/controller/player_selection_controller.dart';

class DraggablePlayerCard extends StatelessWidget {
  final Player player;
  final bool isDragging;
  final VoidCallback? onRemove;

  const DraggablePlayerCard({
    Key? key,
    required this.player,
    this.isDragging = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<Player>(
      data: player,
      feedback: _buildCard(isDragging: true),
      childWhenDragging: Opacity(opacity: 0.3, child: _buildCard()),
      child: _buildCard(),
    );
  }

  Widget _buildCard({bool isDragging = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow:
                isDragging
                    ? [
                      BoxShadow(
                        color: MyColors.greenColor.withValues(alpha: 0.5),
                        blurRadius: 12.r,
                        spreadRadius: 2.r,
                      ),
                    ]
                    : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: CachedNetworkImage(
              imageUrl: player.imageUrl,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    color: MyColors.darkBlueColor,
                    child: Center(
                      child: SizedBox(
                        width: 28.w,
                        height: 28.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            MyColors.greenColor,
                          ),
                        ),
                      ),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color: MyColors.darkBlueColor,
                    child: Icon(
                      Icons.person,
                      size: 25.sp,
                      color: MyColors.white.withValues(alpha: 0.5),
                    ),
                  ),
            ),
          ),
        ),

        SizedBox(height: 6.h),

        // Player name
        Text(
          player.name,
          style: AppTextStyles.captionRegular12().copyWith(
            color: MyColors.white,
            height: 1.5,
            fontSize: 5.sp,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
