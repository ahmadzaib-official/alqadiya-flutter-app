import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/utils/responsive.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showLogoOnRight;
  final List<Widget>? actions;
  final double? peddingValue;
  void Function()? onTap;

  CustomAppBar({
    super.key,
    this.onTap,
    this.showBackButton = false,
    this.showLogoOnRight = false,
    this.actions,
    this.peddingValue,
  });

  @override
  Widget build(BuildContext context) {
    // final homeController = Get.put(DashboardController());

    return AppBar(
      leading:
          // showBackButton
          //     ?
          showLogoOnRight
              ? Image(
                image: AssetImage(MyImages.appicon),
                height: 90.h,
                width: 90.w,
              )
              : Padding(
                padding: EdgeInsetsDirectional.only(
                  start: peddingValue ?? 9.w,
                ), // tighter spacing
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    MyIcons.arrowback,
                    height: 10.h,
                    width: 10.w,
                  ),
                ),
              ),

      // : null,
      backgroundColor: MyColors.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0, // Prevent gray effect when scrolling
      surfaceTintColor: Colors.transparent, // Prevent tint effects
      toolbarHeight: kToolbarHeight, // Standard height
      titleSpacing: showBackButton ? 0 : null, // Reduce title spacing
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class CustomAppBarLogo extends StatelessWidget {
  const CustomAppBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 12,
        right: 16,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: SvgPicture.asset(
          MyImages.logo,
          width: Responsive.width(33, context),
        ),
      ),
    );
  }
}
