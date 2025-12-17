import 'package:alqadiya_game/core/utils/responsive.dart';
import 'package:alqadiya_game/core/utils/spacing.dart';
import 'package:alqadiya_game/core/style/decoration.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/custom_app_widget.dart';
import 'package:alqadiya_game/widgets/spinkkit_ripple_efffect.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
// import 'package:alqadiya_game/features/dash_board/controller/dashboard_controller.dart';
// import 'package:alqadiya_game/features/home/controller/home_screen_controller.dart';
import 'package:alqadiya_game/features/notifcation/controller/notifcation_controller.dart';
import 'package:alqadiya_game/features/notifcation/model/notifcation_modal.dart';
import 'package:alqadiya_game/features/notifcation/widgets/notifcation_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NotifcationScreen extends StatelessWidget {
  NotifcationScreen({super.key});
  final controller = Get.find<NotificationController>();
  // final dashboardController = Get.find<DashboardController>();
  // final homeController = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: _buildAppBar(context),
      ),
      body: RefreshIndicator(
        color: MyColors.backgroundColor,
        onRefresh: controller.refreshNotifications,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent) {
              controller.loadMoreNotifications();
            }
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              children: [
                AppSizedBoxes.smallSizedBox,
                CustomAppWidget(
                  iconPath: MyIcons.notification,
                  title: 'Notifications'.tr,
                  subtitle:
                      'Stay updated on bookings, offers, and all activities in one place.'
                          .tr,
                  showBackgroundImage: true,
                ),
                AppSizedBoxes.largeSizedBox,
                _buildCategoryTabs(context),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.notifications.isEmpty &&
                        !controller.isRefreshing.value) {
                      return NotifcationCardShimmer();
                    }

                    if (controller.filteredNotifications.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return _buildNotificationList();
                  }),
                ),
                Obx(() {
                  return controller.isLoading.value &&
                          !controller.isRefreshing.value &&
                          controller.notifications.isNotEmpty
                      ? SpinkitRipple()
                      : SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 12,
        right: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(MyImages.logo),
          Obx(() {
            return Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(MyIcons.notification),
                    if (controller.unreadCount > 0)
                      Positioned(
                        top: -6,
                        right: -6,
                        child: _buildCustomBadge(count: controller.unreadCount),
                      ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCustomBadge({required int count}) {
    return Container(
      width: 16.w,
      height: 16.h,
      decoration: BoxDecoration(
        color: MyColors.bellred,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        count > 9 ? '9+' : '$count',
        style: AppTextStyles.smallRegular8().copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 9.sp,
          height: 1.1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return Obx(() {
      final categories = ['All', 'Bookings', 'Payments', 'Profile'];

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              categories.map((category) {
                final isSelected =
                    controller.selectedCategory.value == category;

                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => controller.changeCategory(category),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isSelected
                                  ? MyColors.backgroundColor
                                  : MyColors.borderGray,
                          width: 1.5,
                        ),
                        color:
                            isSelected
                                ? MyColors.backgroundColor
                                : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        category.tr,
                        style: AppTextStyles.labelMedium14().copyWith(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      );
    });
  }

  Widget _buildNotificationList() {
    return Obx(() {
      // Filter notifications based on selected category

      return ListView.builder(
        itemCount: controller.filteredNotifications.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final notification = controller.filteredNotifications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              decoration: MyDecorations.containerDecoration.copyWith(
                borderRadius: BorderRadius.circular(14.sp),
              ),
              padding: EdgeInsets.all(9.w),
              child: ListTile(
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(MyIcons.notification, width: 25.w),
                    if (notification.state == 'not_opened')
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Badge(child: SizedBox.shrink()),
                      ),
                  ],
                ),
                title: Text(
                  notification.messageTitle ?? '',
                  style: AppTextStyles.labelRegular14().copyWith(
                    color: MyColors.secondaryText,
                  ),
                ),
                subtitle:
                    notification.messageBody != null
                        ? Text(
                          notification.messageBody!,
                          style: AppTextStyles.captionRegular12().copyWith(
                            color: MyColors.disabledText,
                          ),
                        )
                        : null,
                trailing: Text(
                  formatRelativeTime(notification.createdAt),
                  style: AppTextStyles.labelRegular14().copyWith(
                    color: MyColors.disabledText,
                  ),
                ),
                onTap: () {
                  controller.markAsRead(notification.id ?? '');
                  _handleNotificationTap(notification);
                },
              ),
            ),
          );
        },
      );
    });
  }

  String formatRelativeTime(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString).toLocal(); // Ensure local time
      final now = DateTime.now();

      final minutes = now.difference(date).inMinutes;
      final hours = now.difference(date).inHours;
      final days = now.difference(date).inDays;
      final weeks = (days / 7).floor();
      final months = (days / 30).floor();

      if (minutes < 1) {
        return 'now';
      } else if (minutes < 60) {
        return '${minutes}m';
      } else if (hours < 24) {
        return '${hours}h';
      } else if (days < 7) {
        return '${days}d';
      } else if (weeks < 4) {
        return '${weeks}w';
      } else {
        return '${months}mo';
      }
    } catch (e) {
      return 'Invalid date';
    }
  }

  void _handleNotificationTap(NotificationMessage notification) {
    if (notification.additionalData?.bookingId != null) {
      Get.toNamed(
        AppRoutes.submitBookingDetailes,
        arguments: {'bookingId': notification.additionalData!.bookingId},
      );
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Responsive.height(10, context)),
          Image.asset('assets/images/Notifications.png', width: 100.w),
          SizedBox(height: 16.h),
          Text('No Notifications Yet'.tr, style: AppTextStyles.heading3()),
          SizedBox(height: 8.h),
          Text(
            controller.selectedCategory.value == 'All'
                ? 'Stay tuned — your updates will appear here.'.tr
                : '${'No'.tr} ${controller.selectedCategory.value.tr} ${'notifications found.'.tr}',
            style: AppTextStyles.labelRegular14().copyWith(
              color: MyColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
