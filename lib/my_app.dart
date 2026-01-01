import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:alqadiya_game/core/routes/app_pages.dart';
import 'package:alqadiya_game/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:alqadiya_game/core/services/localization_services.dart';

class MyApp extends StatelessWidget {
  final Locale? locale;
  const MyApp({super.key, this.locale});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Al Qadiya',
          locale: locale,
          getPages: AppPages.pages,
          fallbackLocale: LocalizationService.fallbackLocale,
          translations: LocalizationService(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          theme: AppThemeInfo.themeData,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.scoreboardScreen,
        );
      },
    );
  }
}

// 31277864
// Qwerty@123

// 87654321
// Qwerty@123
