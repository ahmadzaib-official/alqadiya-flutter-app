import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/notification/model/notification_model.dart';
import 'package:alqadiya_game/features/game/widgets/game_background.dart';
import 'package:alqadiya_game/core/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notification = Get.arguments as NotificationModel?;

    if (notification == null) {
      return Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: Center(
          child: Text(
            'Notification not found'.tr,
            style: AppTextStyles.heading1().copyWith(
              color: MyColors.white,
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }

    final isArabic = Get.locale?.languageCode == 'ar';
    final title = isArabic 
        ? (notification.titleInArabic?.isNotEmpty == true ? notification.titleInArabic! : notification.title ?? "") 
        : (notification.title ?? "");
    final body = isArabic 
        ? (notification.bodyInArabic?.isNotEmpty == true ? notification.bodyInArabic! : notification.body ?? "") 
        : (notification.body ?? "");

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        imageUrl: "https://picsum.photos/200",
        body: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              child: HomeHeader(
                title: Text(
                  'Notification Detail'.tr,
                  style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                ),
                actionButtons: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(MyIcons.arrowbackrounded),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Main Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.sp),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: MyColors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Timestamp
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: MyColors.redButtonColor,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _formatDate(notification.createdAt),
                          style: AppTextStyles.heading2().copyWith(
                            fontSize: 7.sp,
                            color: MyColors.redButtonColor,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Title
                    Text(
                      title,
                      style: AppTextStyles.heading1().copyWith(
                        fontSize: 10.sp,
                        color: MyColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 15.h),

                    // Divider
                    Divider(
                      color: MyColors.white.withValues(alpha: 0.1),
                      thickness: 1,
                    ),

                    SizedBox(height: 15.h),

                    // Body/Description - Auto height based on content
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 0.5.sh, // Max 50% of screen height
                      ),
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Text(
                            body,
                            style: AppTextStyles.bodyTextMedium16().copyWith(
                              fontSize: 7.sp,
                              color: MyColors.white.withValues(alpha: 0.8),
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
}
