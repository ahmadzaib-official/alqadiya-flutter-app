import 'package:flutter/services.dart';

class MyImages {
  static const logo = "assets/images/app_logo.svg";
  static const mail = "assets/images/mail.png";
  static const suspect = "assets/images/suspect.png";
  static const suspects = "assets/images/suspects_crop.png";
  static const appicon = "assets/images/app_logo_transparent.png";
  // static const appicon = "assets/images/app_icon.png";
  static const gamebackground = "assets/images/game_background_image.png";
  static const gamesceenshot = "assets/images/game_screenshot.png";
  static const onboard1 = "assets/images/onboarding_1.png";
  static const onboard2 = "assets/images/onbord2.png";
  static const toponbording = "assets/images/toponbording.png";
  static const onboard3 = "assets/images/onbord3.png";
  static const onboard4 = "assets/images/onbord4.png";
  static const onboard5 = "assets/images/onbord5.png";
  static const profile = "assets/images/profile.svg";
  static const booking = "assets/images/booking.svg";
  static const explore = "assets/images/explore.png";
  static const customize = "assets/images/customizestay.svg";
  static const yourdetail = "assets/images/yourdetailes.png";
  static const securebookings = "assets/images/savebookings.png";
  static const discountshape = "assets/images/discountshape.svg";
  static const free = "assets/images/free.svg";
  static const badge = "assets/images/badge.svg";
  static const bazzar = "assets/images/bazzar.png";
  static const loyalitypoints = "assets/images/loyalitypoints.png";
  static const lock = "assets/icons/lock.svg";
  static const points = "assets/images/points.svg";
  static const knetcard = "assets/images/KNETcard.png";

  static Future<Uint8List> getImageBytes(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    return data.buffer.asUint8List();
  }
}
