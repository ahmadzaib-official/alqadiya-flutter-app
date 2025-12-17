import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/splash/controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
// with SingleTickerProviderStateMixin
{
  // late AnimationController _controller;
  // late Animation<double> _scaleAnimation;

  final splashController = Get.find<SplashController>();

  // @override
  // void initState() {
  //   super.initState();
  // _initializeAnimation();
  // }

  // void _initializeAnimation() {
  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 1000),
  //   )..repeat(
  //     reverse: true,
  //   ); // This will make the animation loop back and forth

  //   _scaleAnimation = Tween<double>(
  //     begin: 0.60,
  //     end: 1.0,
  //   ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Stack(
        children: [
          // Center(
          //   child: ScaleTransition(
          //     scale: _scaleAnimation,
          //     child: SvgPicture.asset(MyImages.logo),
          //   ),
          // ),
          Center(child: Image(image: AssetImage(MyImages.appicon))),
          // Center(child: SvgPicture.asset(MyImages.logo)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(
              () => LinearProgressIndicator(
                value: splashController.progress.value,
                minHeight: 20,
                color: MyColors.redButtonColor,
                backgroundColor: Color(0xff10161E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
