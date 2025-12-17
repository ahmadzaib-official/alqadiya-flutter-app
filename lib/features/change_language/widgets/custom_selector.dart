import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadioMedium extends StatelessWidget {
  final bool isSelected;
  final bool isEnabled;

  const CustomRadioMedium({
    super.key,
    required this.isSelected,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.w,
      height: 24.h,
      child: CustomPaint(
        painter: CustomRadioPainter1(
          isSelected: isSelected,
          isEnabled: isEnabled,
        ),
      ),
    );
  }
}

class CustomRadioPainter1 extends CustomPainter {
  final bool isSelected;
  final bool isEnabled;
  final Color selectedColor;
  final Color unselectedBorderColor;

  const CustomRadioPainter1({
    required this.isSelected,
    required this.isEnabled,
    this.selectedColor = const Color(0xFF253583),
    this.unselectedBorderColor = const Color(0xFFC4C4C4),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2.6;
    final Offset center = Offset(radius, radius);

    if (isSelected) {
      final Paint outerPaint =
          Paint()
            ..color = isEnabled ? selectedColor : Colors.grey.shade400
            ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, outerPaint);

      final Paint innerPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius * 0.6, innerPaint);
    } else {
      final Paint borderPaint =
          Paint()
            ..color = isEnabled ? unselectedBorderColor : Colors.grey.shade300
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1;
      canvas.drawCircle(center, radius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomRadioPainter1 oldDelegate) {
    return oldDelegate.isSelected != isSelected ||
        oldDelegate.isEnabled != isEnabled;
  }
}
