import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LanguageSelectionDrawer extends StatelessWidget {
  final String currentLanguage;
  final VoidCallback onEnglishSelected;
  final VoidCallback onArabicSelected;
  final VoidCallback onCloseTap;

  const LanguageSelectionDrawer({
    super.key,
    required this.currentLanguage,
    required this.onEnglishSelected,
    required this.onArabicSelected,
    required this.onCloseTap,
  });

  static void show({
    required String currentLanguage,
    required VoidCallback onEnglishSelected,
    required VoidCallback onArabicSelected,
  }) {
    final context = Get.context!;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      barrierDismissible: true,
      builder:
          (context) => Material(
            type: MaterialType.transparency,
            child: _LanguageDrawerDialog(
              currentLanguage: currentLanguage,
              onEnglishSelected: onEnglishSelected,
              onArabicSelected: onArabicSelected,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Adjust width based on orientation - wider in landscape for better UX
    final drawerWidth = isLandscape ? screenWidth * 0.35 : screenWidth * 0.3;

    return Container(
      width: drawerWidth,
      height: screenHeight,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with Close Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Expanded(
                  child: Text(
                    'Select Language'.tr,
                    style: AppTextStyles.labelBold14().copyWith(
                      fontSize: isLandscape ? 8.sp : 18.sp,
                      color: MyColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // Close Button
                GestureDetector(
                  onTap: onCloseTap,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: MyColors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: MyColors.white,
                      size: isLandscape ? 8.sp : 24.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            color: MyColors.white.withValues(alpha: 0.1),
            height: 1,
            thickness: 1,
          ),

          // Subtitle
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: Text(
              'Please choose your preferred language'.tr,
              style: AppTextStyles.captionSemiBold12().copyWith(
                color: MyColors.white.withValues(alpha: 0.7),
                fontSize: isLandscape ? 7.sp : 10.sp,
              ),
            ),
          ),

          SizedBox(height: isLandscape ? 20.h : 24.h),

          // Language Options - Scrollable to prevent overflow
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  // English Option
                  _buildLanguageOption(
                    context: context,
                    title: "English".tr,
                    flagEmoji: "🇬🇧",
                    isSelected: currentLanguage == "English",
                    onTap: onEnglishSelected,
                    isLandscape: isLandscape,
                  ),

                  SizedBox(height: isLandscape ? 12.h : 16.h),

                  // Arabic Option
                  _buildLanguageOption(
                    context: context,
                    title: "Arabic".tr,
                    flagEmoji: "🇰🇼",
                    isSelected: currentLanguage == "Arabic",
                    onTap: onArabicSelected,
                    isLandscape: isLandscape,
                  ),

                  // Extra spacing at bottom
                  // SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String flagEmoji,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isLandscape,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color:
                isSelected
                    ? MyColors.redButtonColor
                    : MyColors.white.withValues(alpha: 0.15),
            width: isSelected ? 1.w : 1.w,
          ),
          color:
              isSelected
                  ? MyColors.redButtonColor.withValues(alpha: 0.15)
                  : MyColors.black.withValues(alpha: 0.2),
        ),
        child: Row(
          children: [
            // Flag Emoji
            Container(
              padding: EdgeInsets.all(4.w),
              child: Text(
                flagEmoji,
                style: TextStyle(fontSize: isLandscape ? 14.sp : 28.sp),
              ),
            ),
            // Language Name
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.captionSemiBold12().copyWith(
                  color: MyColors.white,
                  fontSize: isLandscape ? 8.sp : 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            // Check Icon
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: MyColors.redButtonColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: MyColors.redButtonColor,
                  size: isLandscape ? 10.sp : 22.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageDrawerDialog extends StatefulWidget {
  final String currentLanguage;
  final VoidCallback onEnglishSelected;
  final VoidCallback onArabicSelected;

  const _LanguageDrawerDialog({
    required this.currentLanguage,
    required this.onEnglishSelected,
    required this.onArabicSelected,
  });

  @override
  State<_LanguageDrawerDialog> createState() => _LanguageDrawerDialogState();
}

class _LanguageDrawerDialogState extends State<_LanguageDrawerDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeDrawer() {
    _controller.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return Stack(
      children: [
        // Backdrop
        GestureDetector(
          onTap: _closeDrawer,
          child: Container(
            color: Colors.black.withValues(alpha: 0.5),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // Drawer positioned on the right, flush with screen edge
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: SlideTransition(
            position: _slideAnimation,
            child: SizedBox(
              height: screenHeight,
              child: LanguageSelectionDrawer(
                currentLanguage: widget.currentLanguage,
                onEnglishSelected: () {
                  widget.onEnglishSelected();
                  _closeDrawer();
                },
                onArabicSelected: () {
                  widget.onArabicSelected();
                  _closeDrawer();
                },
                onCloseTap: _closeDrawer,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
