import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/home/controller/home_controller.dart';
import 'package:alqadiya_game/features/joingame/controller/join_game_controller.dart';
import 'package:alqadiya_game/widgets/custom_textfield.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/start_play_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';

class JoinGameScreen extends StatelessWidget {
  JoinGameScreen({super.key});

  final joinGameController = Get.find<JoinGameController>();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        isPurchased: false,
        imageUrl: "https://picsum.photos/200",
        body: Stack(
          children: [
            Column(
              children: [
                // Top Bar
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.sp,
                    right: 10.sp,
                    top: 5.sp,
                  ),
                  child: HomeHeader(
                    onChromTap: () {},
                    title: Text(
                      'Join the Game'.tr,
                      style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                    ),

                    actionButtons: Row(
                      children: [
                        GestureDetector(
                          onTap: homeController.toggleDrawer,
                          child: SvgPicture.asset(MyIcons.menu),
                        ),
                        SizedBox(width: 5.w),

                        GestureDetector(
                          onTap: () => Get.back(),
                          child: SvgPicture.asset(MyIcons.arrowbackrounded),
                        ),
                      ],
                    ),
                  ),
                ),
                // Body
                Expanded(
                  child: Obx(
                    () =>
                        joinGameController.isWaiting.value
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CupertinoActivityIndicator(
                                  color: Colors.white,
                                  radius: 20.r,
                                ),
                                SizedBox(height: 20.h),
                                Container(
                                  height: 0.1.sh,
                                  width: 0.4.sw,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: MyColors.black.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Waiting for the host to start the game...'
                                        .tr,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.captionRegular12()
                                        .copyWith(
                                          color: MyColors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                          height: 1.5,
                                          fontSize: 7.sp,
                                        ),
                                  ),
                                ),
                              ],
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Case Image
                                Container(
                                  height: 0.6.sh,
                                  padding: EdgeInsets.all(12.sp),

                                  alignment: Alignment.center,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Game Code'.tr,
                                          style: AppTextStyles.heading1()
                                              .copyWith(fontSize: 8.sp),
                                        ),
                                        SizedBox(height: 40.h),
                                        CustomTextfield(
                                          width: 0.25.sw,
                                          fieldTextSize: 7,
                                          hintFontSize: 7,
                                          horizentalContentPadding: 2,
                                          labelVisible: false,
                                          maxLines: 1,
                                          label: 'Paste the code Game'.tr,
                                          hintText: 'Paste the code Game'.tr,
                                          controller:
                                              joinGameController
                                                  .teamCodeController,
                                          suffix: GestureDetector(
                                            onTap: () async {
                                              final data =
                                                  await Clipboard.getData(
                                                    Clipboard.kTextPlain,
                                                  );
                                              if (data != null) {
                                                joinGameController
                                                    .teamCodeController
                                                    .text = data.text ?? '';
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(5.sp),
                                              child: SvgPicture.asset(
                                                MyIcons.paste,
                                              ),
                                            ),
                                          ),
                                          keyboardType: TextInputType.name,
                                        ),
                                        SizedBox(height: 30.h),

                                        Obx(
                                          () => Opacity(
                                            opacity:
                                                joinGameController
                                                        .isLoading
                                                        .value
                                                    ? 0.5
                                                    : 1.0,
                                            child: StartPlayButton(
                                              buttonWidth: 80.w,
                                              onTap:
                                                  joinGameController
                                                          .isLoading
                                                          .value
                                                      ? () {}
                                                      : joinGameController
                                                          .joinGame,
                                              buttonText: 'Join the Game',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),

                                // Right Content
                                Container(
                                  height: 0.5.sh,
                                  padding: EdgeInsets.all(12.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: MyColors.black.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      Text(
                                        'Has the game started?\nYou\'ll only be on the scoreboard.'
                                            .tr,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.captionRegular12()
                                            .copyWith(
                                              color: MyColors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                              height: 1.5,
                                              fontSize: 7.sp,
                                            ),
                                      ),
                                      SizedBox(height: 20.h),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Container(
                                          height: 80.h,
                                          width: 90.w,
                                          padding: EdgeInsets.all(8.sp),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                            color: MyColors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Main Page'.tr,
                                            style:
                                                AppTextStyles.bodyTextMedium16()
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 8.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            ),
            // Drawer Overlay
            Obx(
              () =>
                  homeController.isDrawerOpen.value
                      ? GestureDetector(
                        onTap: () => homeController.toggleDrawer(),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      )
                      : SizedBox.shrink(),
            ),

            // Drawer
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                right: homeController.isDrawerOpen.value ? 0 : -250.w,
                top: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: homeController.buildDrawer(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:alqadiya_game/core/routes/app_routes.dart';
// import 'package:alqadiya_game/core/style/text_styles.dart';
// import 'package:alqadiya_game/features/home/controller/home_controller.dart';
// import 'package:alqadiya_game/widgets/custom_textfield.dart';
// import 'package:alqadiya_game/widgets/game_background.dart';
// import 'package:alqadiya_game/widgets/home_header.dart';
// import 'package:alqadiya_game/widgets/start_play_button.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:alqadiya_game/core/theme/my_colors.dart';

// class JoinGameScreen extends StatefulWidget {
//   JoinGameScreen({super.key});
//   @override
//   State<JoinGameScreen> createState() => _JoinGameScreenState();
// }

// class _JoinGameScreenState extends State<JoinGameScreen> {
//   final TextEditingController teamCodeController = TextEditingController();
//   bool _isWaiting = false;

//   @override
//   void dispose() {
//     teamCodeController.dispose();
//     super.dispose();
//   }

//   void _joinGame() {
//     setState(() {
//       _isWaiting = true;
//     });
//     // Navigate to case video screen after 3 seconds
//     Future.delayed(Duration(seconds: 3), () {
//       if (mounted) {
//         Get.toNamed(AppRoutes.caseVideoScreen);
//       }
//     });
//   }

//   final controller = Get.find<HomeController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyColors.backgroundColor,
//       body: GameBackground(
//         isPurchased: true,
//         imageUrl: "https://picsum.photos/200",
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 // Top Bar
//                 Padding(
//                   padding: EdgeInsets.only(
//                     left: 10.sp,
//                     right: 10.sp,
//                     top: 5.sp,
//                   ),
//                   child: HomeHeader(
//                     onChromTap: () {},
//                     title: Text(
//                       'Join the Game'.tr,
//                       style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
//                     ),

//                     actionButtons: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: controller.toggleDrawer,
//                           child: SvgPicture.asset(MyIcons.menu),
//                         ),
//                         SizedBox(width: 5.w),

//                         GestureDetector(
//                           onTap: () => Get.back(),
//                           child: SvgPicture.asset(MyIcons.arrowbackrounded),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Body
//                 Expanded(
//                   child:
//                       _isWaiting
//                           ? Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CupertinoActivityIndicator(
//                                 color: Colors.white,
//                                 radius: 20.r,
//                               ),
//                               SizedBox(height: 20.h),
//                               Container(
//                                 height: 0.1.sh,
//                                 width: 0.4.sw,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20.r),
//                                   color: MyColors.black.withValues(alpha: 0.1),
//                                 ),
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   'Waiting for the host to start the game...'
//                                       .tr,
//                                   textAlign: TextAlign.center,
//                                   style: AppTextStyles.captionRegular12()
//                                       .copyWith(
//                                         color: MyColors.white.withValues(
//                                           alpha: 0.5,
//                                         ),
//                                         height: 1.5,
//                                         fontSize: 7.sp,
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           )
//                           : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               // Case Image
//                               Container(
//                                 height: 0.6.sh,
//                                 padding: EdgeInsets.all(12.sp),

//                                 alignment: Alignment.center,
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         'Game Code'.tr,
//                                         style: AppTextStyles.heading1()
//                                             .copyWith(fontSize: 8.sp),
//                                       ),
//                                       SizedBox(height: 40.h),
//                                       CustomTextfield(
//                                         width: 0.25.sw,
//                                         fieldTextSize: 7,
//                                         hintFontSize: 7,
//                                         horizentalContentPadding: 2,
//                                         labelVisible: false,
//                                         maxLines: 1,
//                                         label: 'Paste the code Game'.tr,
//                                         hintText: 'Paste the code Game'.tr,
//                                         controller: teamCodeController,
//                                         suffix: GestureDetector(
//                                           onTap: () async {
//                                             final data =
//                                                 await Clipboard.getData(
//                                                   Clipboard.kTextPlain,
//                                                 );
//                                             if (data != null) {
//                                               teamCodeController.text =
//                                                   data.text ?? '';
//                                             }
//                                           },
//                                           child: Padding(
//                                             padding: EdgeInsets.all(5.sp),
//                                             child: SvgPicture.asset(
//                                               MyIcons.paste,
//                                             ),
//                                           ),
//                                         ),
//                                         keyboardType: TextInputType.name,
//                                       ),
//                                       SizedBox(height: 30.h),

//                                       StartPlayButton(
//                                         buttonWidth: 80.w,
//                                         onTap: _joinGame,
//                                         buttonText: 'Join the Game',
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 8.w),

//                               // Right Content
//                               Container(
//                                 height: 0.5.sh,
//                                 padding: EdgeInsets.all(12.sp),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20.r),
//                                   color: MyColors.black.withValues(alpha: 0.1),
//                                 ),
//                                 alignment: Alignment.center,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,

//                                   children: [
//                                     Text(
//                                       'Has the game started?\nYou\'ll only be on the scoreboard.'
//                                           .tr,
//                                       textAlign: TextAlign.center,
//                                       style: AppTextStyles.captionRegular12()
//                                           .copyWith(
//                                             color: MyColors.white.withValues(
//                                               alpha: 0.5,
//                                             ),
//                                             height: 1.5,
//                                             fontSize: 7.sp,
//                                           ),
//                                     ),
//                                     SizedBox(height: 20.h),
//                                     GestureDetector(
//                                       onTap: () {
//                                         Get.back();
//                                       },
//                                       child: Container(
//                                         height: 80.h,
//                                         width: 90.w,
//                                         padding: EdgeInsets.all(8.sp),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             4.r,
//                                           ),
//                                           color: MyColors.white.withValues(
//                                             alpha: 0.05,
//                                           ),
//                                         ),
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           'Main Page'.tr,
//                                           style:
//                                               AppTextStyles.bodyTextMedium16()
//                                                   .copyWith(
//                                                     color: Colors.white,
//                                                     fontSize: 8.sp,
//                                                     fontWeight: FontWeight.w700,
//                                                   ),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ),
//                                     // CustomButton(
//                                     //   fontSize: 8.sp,
//                                     //   text: 'Enter the game'.tr,
//                                     //   onPressed: () {
//                                     //     Get.toNamed(AppRoutes.startGameScreen);
//                                     //   },
//                                     //   backgroundColor: MyColors.white.withValues(
//                                     //     alpha: 0.05,
//                                     //   ),
//                                     // ),
//                                     // Padding(
//                                     //   padding: EdgeInsets.symmetric(horizontal: 5.w),
//                                     // child: CustomButton(
//                                     //   fontSize: 8.sp,
//                                     //   text: 'Enter the game'.tr,
//                                     //   onPressed: () {
//                                     //     Get.toNamed(AppRoutes.startGameScreen);
//                                     //   },
//                                     //   backgroundColor: MyColors.white.withValues(
//                                     //     alpha: 0.05,
//                                     //   ),
//                                     // ),
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                 ),
//               ],
//             ),
//             // Drawer Overlay
//             Obx(
//               () =>
//                   controller.isDrawerOpen.value
//                       ? GestureDetector(
//                         onTap: () => controller.toggleDrawer(),
//                         child: Container(
//                           color: Colors.black.withValues(alpha: 0.5),
//                         ),
//                       )
//                       : SizedBox.shrink(),
//             ),

//             // Drawer
//             Obx(
//               () => AnimatedPositioned(
//                 duration: const Duration(milliseconds: 300),
//                 right: controller.isDrawerOpen.value ? 0 : -250.w,
//                 top: 0,
//                 bottom: 0,
//                 child: SingleChildScrollView(child: controller.buildDrawer()),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
