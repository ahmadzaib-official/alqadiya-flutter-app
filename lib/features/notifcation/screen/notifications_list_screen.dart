import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/notifcation/controller/notifications_provider.dart';
import 'package:alqadiya_game/features/notifcation/model/notification_model.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/localization_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NotificationsListScreen extends StatelessWidget {
  const NotificationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize notifications controller
    final notificationsController = Get.find<NotificationsController>();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        imageUrl: "https://picsum.photos/200",
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              child: Column(
                children: [
                  // Header
                  HomeHeader(
                    onChromTap: () {},
                    title: Text(
                      'Notifications'.tr,
                      style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                    ),
                    actionButtons: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Notification bell with badge
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(
                            MyIcons.notification_brown_rounded,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        // Hamburger menu
                        GestureDetector(
                          onTap: notificationsController.toggleDrawer,
                          child: SvgPicture.asset(MyIcons.menu),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 5.h),
                  // Main Content - Notifications List
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.sp),
                      child: Obx(() {
                        if (notificationsController.isLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: MyColors.redButtonColor,
                            ),
                          );
                        }

                        // Empty state check can be added here
                        if (notificationsController.notifications.isEmpty) {
                          return Center(
                            child: Text(
                              "No notifications".tr,
                              style: AppTextStyles.heading2().copyWith(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                itemCount:
                                    notificationsController
                                        .notifications
                                        .length,
                                separatorBuilder:
                                    (context, index) => SizedBox(height: 8.h),
                                itemBuilder: (context, index) {
                                  final notification =
                                      notificationsController
                                          .notifications[index];
                                  return _buildNotificationCard(
                                    context,
                                    notification,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // Mark as read button
                            GestureDetector(
                              onTap: () {
                                notificationsController.markAllAsRead();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(4.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Mark as read'.tr,
                                  style: AppTextStyles.heading1().copyWith(
                                    fontSize: 7.sp,
                                    color: MyColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  LocalizationFooter(showDividerInColumn: true).buildDivider(),
                  LocalizationFooter(usePositioned: true),
                ],
              ),
            ),
            // Drawer Overlay
            Obx(
              () =>
                  notificationsController.isDrawerOpen.value
                      ? GestureDetector(
                        onTap: () => notificationsController.toggleDrawer(),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      )
                      : SizedBox.shrink(),
            ),

            // Drawer
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                right: notificationsController.isDrawerOpen.value ? 0 : -250.w,
                top: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: notificationsController.buildDrawer(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel notification,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color:
            notification.isRead!
                ? MyColors.black.withValues(alpha: 0.1)
                : MyColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Text content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timestamp
                Text(
                  notification.createdAt.toString(),
                  style: AppTextStyles.heading2().copyWith(
                    fontSize: 6.sp,
                    color: MyColors.redButtonColor,
                  ),
                ),
                SizedBox(height: 5.h),
                // Title
                Row(
                  children: [
                    Text(
                      notification.title ?? "",
                      style: AppTextStyles.heading1().copyWith(
                        fontSize: 7.sp,
                        color: MyColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    // Description
                    Expanded(
                      child: Text(
                        notification.body ?? "",
                        style: AppTextStyles.heading2().copyWith(
                          fontSize: 6.sp,
                          color: MyColors.white.withValues(alpha: 0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 3.w),

          // Right side - View more button
          GestureDetector(
            onTap: () {
              // Navigate to notification detail or perform action
            },
            child: Container(
              width: 60.w,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: MyColors.greenColor,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Spacer(flex: 6),
                  Text(
                    'View more'.tr,
                    style: AppTextStyles.heading2().copyWith(
                      fontSize: 6.sp,
                      color: MyColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(flex: 1),
                  SvgPicture.asset(MyIcons.arrow_right),
                  Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
