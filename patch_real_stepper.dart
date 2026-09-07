import 'dart:io';

void main() {
  var file = File('lib/features/game/widget/question_stepper.dart');
  var content = '''
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionStepper extends StatefulWidget {
  final int currentQuestion;
  final int totalQuestions;
  final Function(int)? onQuestionTapped;
  final Color backgroundColor;
  final Color currentColor;
  final Color totalColor;
  final Color lineColor;
  final Color dotColor;

  const QuestionStepper({
    Key? key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.onQuestionTapped,
    this.backgroundColor = Colors.white,
    this.currentColor = MyColors.greenColor,
    this.totalColor = const Color(0xFF141B25),
    this.lineColor = Colors.white,
    this.dotColor = const Color(0xff141B25),
  }) : super(key: key);

  @override
  State<QuestionStepper> createState() => _QuestionStepperState();
}

class _QuestionStepperState extends State<QuestionStepper>
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
  void didUpdateWidget(QuestionStepper oldWidget) {
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
    final total = widget.totalQuestions > 0 ? widget.totalQuestions : 1;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        final int questionNumber = index + 1;
        final bool isPast = questionNumber < widget.currentQuestion;
        final bool isCurrent = questionNumber == widget.currentQuestion;
        final bool isTotal = questionNumber == total;
        
        Widget node;
        
        if (isPast) {
          node = GestureDetector(
            onTap: () {
              if (widget.onQuestionTapped != null) {
                // index is 0-based
                widget.onQuestionTapped!(index);
              }
            },
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: widget.totalColor,
                borderRadius: BorderRadius.circular(200.r),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Center(
                child: Text(
                  questionNumber.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 5.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        } else if (isCurrent) {
          node = AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 30,
                  height: 35,
                  decoration: BoxDecoration(
                    color: widget.currentColor,
                    borderRadius: BorderRadius.circular(200.r),
                    border: Border.all(color: Colors.white, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: widget.currentColor.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      questionNumber.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (isTotal) {
          node = Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: widget.totalColor,
              borderRadius: BorderRadius.circular(200.r),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Center(
              child: Text(
                questionNumber.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else {
          // Future question (white dot)
          node = Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: widget.lineColor,
              shape: BoxShape.circle,
            ),
          );
        }

        if (index == total - 1) {
          return node;
        }

        // Connecting line
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            node,
            Container(width: 20, height: 3, color: widget.lineColor),
          ],
        );
      }),
    );
  }
}
''';
  file.writeAsStringSync(content);
}
