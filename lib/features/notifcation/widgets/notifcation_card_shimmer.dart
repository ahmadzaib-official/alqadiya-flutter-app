import 'package:alqadiya_game/core/style/decoration.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotifcationCardShimmer extends StatelessWidget {
  const NotifcationCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Show 5 shimmer items
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Container(
            decoration: MyDecorations.containerDecoration.copyWith(
              color: MyColors.fillColor, // Light grey background
              borderRadius: BorderRadius.circular(14.sp),
            ),
            padding: EdgeInsets.all(9.w),
            child: ListTile(
              leading: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      color: MyColors.lightGray, // Slightly darker grey
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[400], // Badge color
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              title: Container(
                width: double.infinity,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              subtitle: Container(
                width: double.infinity,
                height: 14.h,
                margin: EdgeInsets.only(top: 6.h),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              trailing: Container(
                width: 60.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
