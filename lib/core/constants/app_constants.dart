import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  static double defaultRadius = 6.r;

  static double paddingOnly = 12.w;

  static final EdgeInsets defaultPaddingHorizental = EdgeInsets.symmetric(
    horizontal: paddingOnly,
  );
  static final EdgeInsets defaultAuthPaddingHorizental = EdgeInsets.symmetric(
    horizontal: 31.w,
  );
  static final EdgeInsets defaultAllPadding = EdgeInsets.all(24);
}
