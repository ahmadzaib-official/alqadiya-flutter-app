import 'package:alqadiya_game/core/services/localization_services.dart';
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
  final locale = await LocalizationService.getCurrentLocale();
  runApp(MyApp(locale: locale));
}

// 31277864
// Qwerty@123

// 87654321
// Qwerty@123