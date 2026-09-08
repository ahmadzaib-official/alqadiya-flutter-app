import 'dart:async';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EvidenceUnlockedDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool showIcon;
  final VoidCallback onDismiss;

  const EvidenceUnlockedDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    this.showIcon = true,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<EvidenceUnlockedDialog> createState() => _EvidenceUnlockedDialogState();
}

class _EvidenceUnlockedDialogState extends State<EvidenceUnlockedDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Auto dismiss after 4 seconds
    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 110.w),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: 45.h,
            ), // Push down to allow icon to float
            padding: EdgeInsets.only(
              top: widget.showIcon ? 55.h : 20.h,
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF141B25), // Dark background
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(
                  0xFFE84C62,
                ).withValues(alpha: 0.5), // Reddish border
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  widget.title,
                  style: AppTextStyles.heading1().copyWith(
                    color: MyColors.greenColor,
                    fontSize: 10.sp, // Made it larger for exact match
                  ),
                  textAlign: TextAlign.center,
                ),
                // SizedBox(height: 10.h),
                // Subtitle
                Text(
                  widget.subtitle,
                  style: AppTextStyles.bodyTextRegular16().copyWith(
                    color: Colors.white,
                    fontSize: 8.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                // OK Button
                SizedBox(
                  width: 100.w,
                  child: ElevatedButton(
                    onPressed: () {
                      _timer?.cancel();
                      widget.onDismiss();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.greenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30.r,
                        ), // Fully rounded pill shape
                      ),
                      // padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: Text(
                      'OK'.tr,
                      style: AppTextStyles.heading2().copyWith(
                        color: Colors.white,
                        fontSize: 8.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Floating Icon
          if (widget.showIcon)
            Positioned(
            top: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 90.h,
                  height: 90.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF141B25), // Match dialog bg
                    border: Border.all(color: MyColors.greenColor, width: 2.5),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.folder_rounded,
                      color: const Color(
                        0xFFA2E891,
                      ), // light green filled folder
                      size: 45.h,
                      shadows: [
                        Shadow(color: MyColors.greenColor, blurRadius: 15),
                      ],
                    ),
                  ),
                ),
                // Left sparkle
                Positioned(
                  left: -15,
                  child: Icon(
                    Icons.star,
                    color: MyColors.greenColor,
                    size: 15.h,
                  ),
                ),
                // Right sparkle
                Positioned(
                  right: -15,
                  child: Icon(
                    Icons.star,
                    color: MyColors.greenColor,
                    size: 15.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
