import 'package:alqadiya_game/core/services/localization_services.dart';
import 'package:alqadiya_game/core/services/notification_service.dart';
import 'package:alqadiya_game/core/services/services.dart';
import 'package:alqadiya_game/my_app.dart' show MyApp;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
  print('Background message data: ${message.data}');

  // You can show a notification here if needed
  if (message.notification != null) {
    print('Background notification: ${message.notification?.title}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

  // Initialize notifications properly
  if (!kIsWeb) {
    await NotificationService.initNotifications();
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
