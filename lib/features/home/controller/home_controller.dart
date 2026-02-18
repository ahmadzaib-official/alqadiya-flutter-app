import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/services/auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/widgets/home_menu/home_drawer_menu.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
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
          icon: MyIcons.user,
          label: 'Profile'.tr,
          onTap: () {
            closeDrawer();
            AuthGuard.executeIfAuthenticated(
              title: 'Profile Access'.tr,
              message: 'Please sign in to view your profile'.tr,
              action: () => Get.toNamed(AppRoutes.settingsScreen),
            );
          },
        ),
        DrawerMenuItem(
          icon: MyIcons.coins,
          label: 'My purchases'.tr,
          onTap: () {
            closeDrawer();
            AuthGuard.executeIfAuthenticated(
              title: 'Purchase History'.tr,
              message: 'Please sign in to view your purchase history'.tr,
              action: () => Get.toNamed(AppRoutes.transactionsListScreen),
            );
          },
        ),
        DrawerMenuItem(
          icon: MyIcons.settings,
          label: 'Settings'.tr,
          onTap: () {
            closeDrawer();
            AuthGuard.executeIfAuthenticated(
              title: 'Settings Access'.tr,
              message: 'Please sign in to access settings'.tr,
              action: () => Get.toNamed(AppRoutes.settingsScreen),
            );
          },
        ),
        DrawerMenuItem(
          icon: MyIcons.circlequestionmark,
          label: 'FAQ & Support'.tr,
          onTap: () async {
            closeDrawer();
 final url = Uri.parse('http://51.112.131.120/faqs');

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
}
