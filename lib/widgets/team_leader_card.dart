import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamLeaderCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const TeamLeaderCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar with selection indicator
          Stack(
            alignment: Alignment.center,
            children: [
              // Avatar circle
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          color: MyColors.darkBlueColor,
                          child: Center(
                            child: SizedBox(
                              width: 28.w,
                              height: 28.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
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

              // Selection checkmark
              if (isSelected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: SvgPicture.asset(MyIcons.green_check, width: 10.w),
                ),
            ],
          ),

          SizedBox(height: 6.h),

          // Leader name
          Text(
            name,
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
      ),
    );
  }
}
