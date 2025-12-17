import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/widgets/auth_heading.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:flutter/material.dart' hide TooltipPositionDelegate;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  // final _controller = SuperTooltipController();
  late List<JustTheController> tooltipControllers;
  int currentTooltipIndex = 0;

  final List<String> tooltipTexts = [
    'Time taken to play',
    'Your Points here',
    'Game status',
  ];

  final List<Offset> tooltipPositions = [
    const Offset(120, 5),
    const Offset(350, 60),
    const Offset(80, 110),
  ];

  @override
  void initState() {
    tooltipControllers = List.generate(
      tooltipTexts.length,
      (index) => JustTheController(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCurrentTooltip();
    });
    super.initState();
  }

  void _showCurrentTooltip() {
    if (currentTooltipIndex > 0) {
      tooltipControllers[currentTooltipIndex - 1].hideTooltip();
    }
    if (currentTooltipIndex < tooltipControllers.length) {
      tooltipControllers[currentTooltipIndex].showTooltip();
    }
  }

  void _moveToNextTooltip() {
    if (currentTooltipIndex < tooltipControllers.length - 1) {
      tooltipControllers[currentTooltipIndex].hideTooltip();
      setState(() {
        currentTooltipIndex++;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCurrentTooltip();
      });
    } else {
      tooltipControllers[currentTooltipIndex].hideTooltip();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: AuthHeading(
                screenHeight: screenHeight,
                actionButtonIcon: MyImages.lock,
                actionButtonText: 'Log in',
                onTap: () {
                  tooltipControllers[currentTooltipIndex].hideTooltip();
                  Get.offNamedUntil(AppRoutes.sigin, (route) => false);
                },
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                // JustTheTooltip.(context);
              },
              child: Stack(
                children: [
                  Container(
                    height: screenHeight * 0.24,
                    width: screenWidth * 0.8,
                    margin: const EdgeInsets.all(16),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.redButtonColor.withValues(
                            alpha: 0.15,
                          ),
                          spreadRadius: 10,
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(MyImages.gamesceenshot),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  ...List.generate(
                    tooltipTexts.length,
                    (index) => Positioned(
                      top: index == 1 ? null : tooltipPositions[index].dy.sp,
                      left: index == 1 ? null : tooltipPositions[index].dx.sp,
                      bottom: index == 1 ? -10.sp : null,
                      right: index == 1 ? 50.sp : null,
                      child: JustTheTooltip(
                        tailBuilder: (tip, point2, point3) {
                          return Path()
                            ..moveTo(tip.dx, tip.dy)
                            ..lineTo(point2.dx, point2.dy)
                            ..lineTo(point3.dx, point3.dy)
                            ..close();
                        },
                        backgroundColor: Colors.white,
                        controller: tooltipControllers[index],
                        preferredDirection:
                            index == 1 ? AxisDirection.down : AxisDirection.up,
                        offset: -20,
                        barrierDismissible: false,
                        isModal: true,
                        content: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.sp,
                            vertical: 8.sp,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tooltipTexts[index],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _moveToNextTooltip();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 5.sp,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.sp,
                                    vertical: 5.sp,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Got it',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: Icon(Icons.add, size: 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: CustomButton(
                text: 'Got it',
                onPressed: () {
                  tooltipControllers[currentTooltipIndex].hideTooltip();
                  Get.offNamedUntil(AppRoutes.sigin, (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
