// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:alqadiya_game/core/theme/my_colors.dart';
// import 'package:alqadiya_game/core/constants/my_icons.dart';
// // import 'package:alqadiya_game/widgets/home_menu/home_top_bar.dart';
// // import 'package:alqadiya_game/widgets/home_menu/home_logo_section.dart';
// // import 'package:alqadiya_game/widgets/home_menu/home_action_button.dart';
// // import 'package:alqadiya_game/widgets/home_menu/language_toggle_button.dart';
// import 'package:alqadiya_game/features/home/home_controller.dart';

// class HomeMenuScreen extends StatelessWidget {
//   HomeMenuScreen({super.key});

//   final controller = Get.put(HomeController());

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.sizeOf(context).height;

//     return Scaffold(
//       backgroundColor: MyColors.backgroundColor,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Main Content
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // Top Bar with Close Button
//                   HomeTopBar(
//                     onMenuTap: () => controller.toggleDrawer(),
//                     onSearchTap: () {},
//                     onLanguageTap: () {},
//                     showCloseButton: true,
//                     onCloseTap: () => controller.closeDrawer(),
//                   ),

//                   // Breadcrumb
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Main Menu / Home - Menu',
//                         style: TextStyle(
//                           color: MyColors.white.withValues(alpha: 0.5),
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: screenHeight * 0.08),

//                   // Logo Section
//                   HomeLogoSection(height: 120.h),

//                   SizedBox(height: screenHeight * 0.06),

//                   // Action Buttons (Case Store & Join the Game)
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         HomeActionButton(
//                           icon: MyIcons.shopping,
//                           label: 'Case Store',
//                           onTap: () {
//                             // Navigate to Case Store
//                           },
//                         ),
//                         HomeActionButton(
//                           icon: MyIcons.play,
//                           label: 'Join the Game',
//                           onTap: () {
//                             // Navigate to Join Game
//                           },
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(height: screenHeight * 0.15),

//                   // Language Toggle Button
//                   LanguageToggleButton(
//                     currentLanguage: 'عربي',
//                     onTap: () => controller.toggleLanguage(),
//                   ),

//                   SizedBox(height: 20.h),
//                 ],
//               ),
//             ),

//             // Drawer Overlay
//             GestureDetector(
//               onTap: () => controller.closeDrawer(),
//               child: Container(color: Colors.black.withValues(alpha: 0.5)),
//             ),

//             // Drawer (Always visible in this screen)
//             Positioned(
//               right: 0,
//               top: 0,
//               bottom: 0,
//               child: SingleChildScrollView(child: controller.buildDrawer()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
