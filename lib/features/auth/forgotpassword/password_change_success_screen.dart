// import 'package:alqadiya_game/core/constants/my_icons.dart';
// import 'package:alqadiya_game/core/routes/app_routes.dart';
// import 'package:alqadiya_game/core/utils/spacing.dart';
// import 'package:alqadiya_game/core/theme/my_colors.dart';
// import 'package:alqadiya_game/core/style/text_styles.dart';
// import 'package:alqadiya_game/widgets/animation_entry_wrapper.dart';
// import 'package:alqadiya_game/widgets/custom_button.dart';
// import 'package:alqadiya_game/widgets/custom_header.dart';
// import 'package:alqadiya_game/widgets/textfield_widget.dart';
// import 'package:alqadiya_game/features/auth/controller/signin_controller.dart';
// import 'package:alqadiya_game/core/utils/validator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';

// class PasswordChangeSuccessScreen extends StatelessWidget {
//   PasswordChangeSuccessScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.sizeOf(context).height;

//     return Scaffold(
//       backgroundColor: MyColors.backgroundColor,

//       body: SafeArea(
//         child: GetBuilder(
//           init: SignInController(),
//           builder: (controller) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: AnimatedEntryWrapper(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomHeader(showLogoOnLeft: true),
//                     SizedBox(height: screenHeight * 0.1),

//                       SvgPicture.asset(
//                      MyIcons.rectangleellipsis,
//                       ),
//                       AppSizedBoxes.largeSizedBox,

//                       Text(
//                         title,
//                         style: AppTextStyles.heading1().copyWith(
//                           fontSize: 30.sp,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       AppSizedBoxes.smallSizedBox,
//                       Text(
//                         message,
//                         style: AppTextStyles.bodyTextRegular16().copyWith(
//                           color: MyColors.secondaryText,
//                           fontSize: 16.sp,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       AppSizedBoxes.largeSizedBox,
                     
//                       CustomButton(
//                           isLoading: false,
//                           text: 'Log in to the app'.tr,
//                           onPressed: () {
//                              Get.offAllNamed(AppRoutes.sigin);
//                           },
//                         ),
//                       AppSizedBoxes.largeSizedBox,
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
