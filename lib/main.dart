import 'package:alqadiya_game/core/services/localization_services.dart';
import 'package:alqadiya_game/core/services/notification_service.dart';
import 'package:alqadiya_game/core/services/services.dart';
import 'package:alqadiya_game/my_app.dart' show MyApp;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await Services().initServices();
  // Initialize local notifications with enhanced setup
  if (!kIsWeb) {
    await NotificationService.localNotiInit();
    await NotificationService.getDeviceToken();
  }

  final locale = await LocalizationService.getCurrentLocale();
  runApp(MyApp(locale: locale));
}

// 98765432
// Raheel@123

// 12345670000
// Shery12345@

// 3155189866
// Ra123*@123
