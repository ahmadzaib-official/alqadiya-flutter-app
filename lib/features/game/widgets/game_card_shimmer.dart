import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class GameCardShimmer extends StatelessWidget {
  const GameCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Container(
      width: size.width * 0.22,
      margin: EdgeInsets.only(left: 15.w),
      alignment: Alignment.center,
      child: Shimmer.fromColors(
        baseColor: MyColors.backgroundColor.withValues(alpha: 0.3),
        highlightColor: MyColors.white.withValues(alpha: 0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image placeholder
            Container(
              width: double.infinity,
              height: size.height * 0.34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40.r)),
              ),
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(5.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title placeholder
                  Container(
                    width: size.width * 0.15,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  // Description placeholder (2 lines)
                  Container(
                    width: size.width * 0.18,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    width: size.width * 0.14,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Button placeholder
                  Container(
                    width: 60.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
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
