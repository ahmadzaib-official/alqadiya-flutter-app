import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/debug/debug_point.dart';

class Savedcloseddialog {
   static Future<void> safeCloseDialog() async {
    try {
      await Future.delayed(Duration.zero); // Let UI update
      if (Get.isDialogOpen! && Navigator.of(Get.context!).canPop()) {
        Navigator.of(Get.context!).pop(); // Force close
      }
    } catch (e) {
      DebugPoint.log("Dialog close error: $e");
    }
  }

}