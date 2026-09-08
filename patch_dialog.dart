import 'dart:io';

void main() {
  var file = File('lib/features/game/widget/evidence_unlocked_dialog.dart');
  var content = file.readAsStringSync();

  final oldBuild = '''
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF141B25), // Dark background matching design
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: MyColors.redButtonColor.withValues(alpha: 0.5),
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
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Glow effect folder icon
                    Container(
                      width: 60.h,
                      height: 60.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            MyColors.greenColor.withValues(alpha: 0.5),
                            Colors.transparent,
                          ],
                          radius: 0.8,
                        ),
                        border: Border.all(
                          color: MyColors.greenColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.folder_open_rounded,
                          color: const Color(0xFFA2E891), // light green folder
                          size: 30.h,
                          shadows: [
                            Shadow(color: MyColors.greenColor, blurRadius: 10),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Title
                    Text(
                      widget.title,
                      style: AppTextStyles.heading1().copyWith(
                        color: MyColors.greenColor,
                        fontSize: 8.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.h),
                    // Subtitle
                    Text(
                      widget.subtitle,
                      style: AppTextStyles.bodyTextRegular16().copyWith(
                        color: Colors.white,
                        fontSize: 6.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15.h),
                    // OK Button
                    SizedBox(
                      width: 120.w,
                      child: ElevatedButton(
                        onPressed: () {
                          _timer?.cancel();
                          widget.onDismiss();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.greenColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                        ),
                        child: Text(
                          'OK'.tr,
                          style: AppTextStyles.heading2().copyWith(
                            color: Colors.white,
                            fontSize: 7.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
''';

  final newBuild = '''
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 45.h), // Push down to allow icon to float
            padding: EdgeInsets.only(
              top: 55.h,
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF141B25), // Dark background
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFFE84C62).withValues(alpha: 0.5), // Reddish border
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
                    fontSize: 20.sp, // Made it larger for exact match
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                // Subtitle
                Text(
                  widget.subtitle,
                  style: AppTextStyles.bodyTextRegular16().copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                // OK Button
                SizedBox(
                  width: 160.w,
                  child: ElevatedButton(
                    onPressed: () {
                      _timer?.cancel();
                      widget.onDismiss();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.greenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r), // Fully rounded pill shape
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: Text(
                      'OK'.tr,
                      style: AppTextStyles.heading2().copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Floating Icon
          Positioned(
            top: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect behind the circle
                Container(
                  width: 90.h,
                  height: 90.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.greenColor.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                // The circular border
                Container(
                  width: 90.h,
                  height: 90.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF141B25), // Match dialog bg
                    border: Border.all(
                      color: MyColors.greenColor,
                      width: 2.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.folder_rounded,
                      color: const Color(0xFFA2E891), // light green filled folder
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
                  child: Icon(Icons.star, color: MyColors.greenColor, size: 15.h),
                ),
                // Right sparkle
                Positioned(
                  right: -15,
                  child: Icon(Icons.star, color: MyColors.greenColor, size: 15.h),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
''';

  if (content.contains(oldBuild)) {
    content = content.replaceAll(oldBuild, newBuild);
    file.writeAsStringSync(content);
    print('Dialog patched successfully');
  } else {
    print('Failed to patch dialog: Content not found');
  }
}
