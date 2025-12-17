import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/widgets/language_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';

class DrawerMenuItem {
  final String icon;
  final String label;
  final VoidCallback onTap;

  DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class HomeDrawerMenu extends StatelessWidget {
  final List<DrawerMenuItem> menuItems;
  final VoidCallback onCloseTap;

  const HomeDrawerMenu({
    Key? key,
    required this.menuItems,
    required this.onCloseTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      height: MediaQuery.sizeOf(context).height,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: MyColors.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(-10, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Close Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: onCloseTap,
                child: SvgPicture.asset(MyIcons.close),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return GestureDetector(
                  onTap: item.onTap,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30.h),

                    child: Row(
                      children: [
                        SvgPicture.asset(item.icon, width: 28.w, height: 28.h),
                        SizedBox(width: 10.w),
                        Text(
                          item.label,
                          style: AppTextStyles.labelMedium14().copyWith(
                            color: MyColors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.bold,
                            fontSize: 7.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LanguageSelectionButton(
                height: 50.h,
                width: 40.w,
                margin: EdgeInsets.only(left: 12.w),
                color: MyColors.black.withValues(alpha: 0.2),
                textFontSize: 6.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
