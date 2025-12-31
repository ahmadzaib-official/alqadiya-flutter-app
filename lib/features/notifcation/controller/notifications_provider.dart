import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/widgets/home_menu/home_drawer_menu.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/features/notifcation/repository/notification_repository.dart';
import 'package:alqadiya_game/features/notifcation/model/notification_model.dart';
import 'package:url_launcher/url_launcher.dart';

/// Controller for managing notifications screen state
class NotificationsController extends GetxController {
  final _repository = NotificationRepository();
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await _repository.getNotifications();
        if(response.statusCode==200||response.statusCode==201){

        notifications.assignAll(
          (response.data as List).map((e) => NotificationModel.fromJson(e)).toList(),
        );
      }
    } on DioException catch (e) {
      // Error already shown by interceptor
      print('Error fetching notifications: $e');
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  int get unreadCount => notifications.where((n) => !n.isRead!).length;

  final isDrawerOpen = false.obs;
  final currentLanguage = 'عربي'.obs;

  void toggleDrawer() {
    isDrawerOpen.toggle();
  }

  void closeDrawer() {
    isDrawerOpen.value = false;
  }

  void toggleLanguage() {
    currentLanguage.value = currentLanguage.value == 'عربي' ? 'EN' : 'عربي';
  }

  Widget buildDrawer() {
    return HomeDrawerMenu(
      menuItems: [
        DrawerMenuItem(
          icon: MyIcons.coins,
          label: 'My purchases'.tr,
          onTap: () {
            closeDrawer();
            // Navigate to purchases
            Get.toNamed(AppRoutes.transactionsListScreen);
          },
        ),
        DrawerMenuItem(
          icon: MyIcons.settings,
          label: 'Settings'.tr,
          onTap: () {
            closeDrawer();
            // Navigate to settings
            Get.toNamed(AppRoutes.settingsScreen);
          },
        ),
        DrawerMenuItem(
          icon: MyIcons.circlequestionmark,
          label: 'FAQ & Support'.tr,
          onTap: () async {
            closeDrawer();

            final url = Uri.parse('http://51.112.131.120/admin/support');

            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              Get.log('Could not launch $url');
            }
          },
        ),
      ],
      onCloseTap: () => closeDrawer(),
    );
  }

  /// Mark all notifications as read
  /// Mark all notifications as read
  void markAllAsRead() {
    // Implement API call here if needed
    // for (var notification in notifications) {
    //   notification.isRead = true; // NotificationModel is final, need to handle this or ignore for now as API isn't ready for updates
    // }
    update();
  }

  /// Mark a specific notification as read
  /// Mark a specific notification as read
  void markAsRead(int index) {
      // Implement API call
      update();
  }
}
