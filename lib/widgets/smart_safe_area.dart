import 'package:flutter/material.dart';

class SmartSafeArea extends StatelessWidget {
  final Widget child;

  const SmartSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewPadding;

    return Padding(
      padding: EdgeInsets.only(
        top: padding.top > 0 ? padding.top : 0,
        bottom: padding.bottom > 0 ? padding.bottom : 0,
        left: padding.left > 0 ? padding.left : 0,
        right: padding.right > 0 ? padding.right : 0,
      ),
      child: child,
    );
  }
}
