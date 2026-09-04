import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinkitRipple extends StatelessWidget {
  final Color color;
  const SpinkitRipple({super.key, this.color = MyColors.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(child: SpinKitRipple(color: color, size: 40.0)),
    );
  }
}
