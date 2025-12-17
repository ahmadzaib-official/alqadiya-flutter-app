import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamProgressIndicator extends StatefulWidget {
  final int currentQuestion;
  final int totalQuestions;
  final Color backgroundColor;
  final Color currentColor;
  final Color totalColor;
  final Color lineColor;
  final Color dotColor;

  const TeamProgressIndicator({
    Key? key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.backgroundColor = Colors.white,
    this.currentColor = MyColors.greenColor,
    this.totalColor = MyColors.greenColor,
    this.lineColor = Colors.white,
    this.dotColor = const Color(0xff141B25),
  }) : super(key: key);

  @override
  State<TeamProgressIndicator> createState() => _TeamProgressIndicatorState();
}

class _TeamProgressIndicatorState extends State<TeamProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(TeamProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentQuestion != widget.currentQuestion) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current question circle (green)
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 30.h,
                height: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200.r),
                  border: Border.all(color: MyColors.redButtonColor, width: 1),
                ),
                child: Center(
                  child: Text(
                    widget.totalQuestions.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: MyColors.redButtonColor,
                      fontSize: 5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // // Line to current question
        Container(width: 15.h, height: 3.h, color: MyColors.redButtonColor),
        // // Starting dot (white)
        Container(
          width: 18.h,
          height: 18.h,
          decoration: BoxDecoration(
            border: Border.all(color: MyColors.redButtonColor, width: 1),
            shape: BoxShape.circle,
          ),
        ),
        // // Line to current question
        Container(width: 15.h, height: 3.h, color: MyColors.redButtonColor),
        // Total questions circle (dark) - NO SPACING
        Container(
          width: 35.h,
          height: 35.h,
          decoration: BoxDecoration(
            color: widget.totalColor,
            borderRadius: BorderRadius.circular(200.r),
            border: Border.all(color: MyColors.redButtonColor, width: 1),
          ),
          child: Center(
            child: Text(
              widget.currentQuestion.toString().padLeft(2, '0'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 6.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // // Line to current question
        Container(width: 15.h, height: 3.h, color: MyColors.redButtonColor),
        // // Starting dot (white)
        Container(
          width: 18.h,
          height: 18.h,
          decoration: BoxDecoration(
            border: Border.all(color: MyColors.redButtonColor, width: 1),
            shape: BoxShape.circle,
          ),
        ),

        // // Line to current question
        Container(width: 15.h, height: 3.h, color: MyColors.redButtonColor),
        // // Starting dot (white)
        Container(
          width: 18.h,
          height: 18.h,
          decoration: BoxDecoration(
            border: Border.all(color: MyColors.redButtonColor, width: 1),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}