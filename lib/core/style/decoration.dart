import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';

class MyDecorations {
  static BoxDecoration containerDecoration = BoxDecoration(
    color: MyColors.fillColor,
    borderRadius: const BorderRadius.all(Radius.circular(8)),
  );
  static BoxDecoration containerDecorationYellow = BoxDecoration(
    color: MyColors.lightYellow,
    borderRadius: const BorderRadius.all(Radius.circular(18)),
  );
  static BoxDecoration containerDecorationredlight = BoxDecoration(
    color: MyColors.lightPink,
    borderRadius: const BorderRadius.all(Radius.circular(13)),
  );
  static BoxDecoration containerDecorationbluelight = BoxDecoration(
    color: MyColors.lightBlue,
    borderRadius: const BorderRadius.all(Radius.circular(7)),
  );
  static BoxDecoration containerDecorationround = BoxDecoration(
    color: MyColors.fillColor,
    borderRadius: const BorderRadius.all(Radius.circular(30)),
  );

  static BoxDecoration decorationBlue = BoxDecoration(
    color: MyColors.backgroundColor,
    borderRadius: BorderRadius.circular(10.0),
  );
}
