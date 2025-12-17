import 'package:alqadiya_game/core/routes/app_routes.dart';
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
          icon: MyIcons.coins,
          label: 'My purchases',
          onTap: () {
            closeDrawer();
            // Navigate to purchases
            Get.toNamed(AppRoutes.transactionsListScreen);
          },
        ),
        DrawerMenuItem(
          icon: MyIcons.settings,
          label: 'Settings',
          onTap: () {
            closeDrawer();
            // Navigate to settings
            Get.toNamed(AppRoutes.settingsScreen);
          },
        ),
        DrawerMenuItem(
          icon: MyIcons.circlequestionmark,
          label: 'FAQ & Support',
          onTap: () async {
            closeDrawer();

            final url = Uri.parse('https://www.google.com');

            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              debugPrint('Could not launch $url');
            }
          },
        ),
      ],
      onCloseTap: () => closeDrawer(),
    );
  }
}
