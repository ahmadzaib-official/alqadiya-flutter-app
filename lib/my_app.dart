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
          initialRoute: AppRoutes.splash,
        );
      },
    );
  }
}

// live
// 31277864
// Qwerty@123

// 87654322
// Qwerty@123

// local
// 0000000
// Qwerty@123

// 1234569
// Qwerty@123

// 1234568
// Qwerty@123


// Owner: CN=AhmadZaib, OU=mtrsl, O=MentorSol, L=Lahore, ST=Punjab, C=PK
// Issuer: CN=AhmadZaib, OU=mtrsl, O=MentorSol, L=Lahore, ST=Punjab, C=PK
// Serial number: 13ecf3e064e9ee82
// Valid from: Fri Dec 12 15:35:24 PKT 2025 until: Sun Dec 01 15:35:24 PKT 9991
// Certificate fingerprints:
//          SHA1: 2F:B2:73:D1:AD:44:C8:C3:87:23:5E:A7:10:B2:88:65:C4:82:46:68
//          SHA256: ED:2D:C2:51:79:E6:A6:3B:60:6E:68:ED:8E:EC:C3:53:35:61:DB:B3:42:43:A3:1D:80:B7:A7:80:D0:C7:F7:77
// Signature algorithm name: SHA384withRSA
// Subject Public Key Algorithm: 2048-bit RSA key
// Version: 3