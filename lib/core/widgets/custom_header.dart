import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({
    super.key,
    required this.showLogoOnLeft,
    this.peddingValue,
    this.onBack,
  });

  final bool showLogoOnLeft;
  final double? peddingValue;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showLogoOnLeft
            ? Image(image: AssetImage(MyImages.appicon), height: 60.h)
            : GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
              child: SvgPicture.asset(
                MyIcons.arrowback,
                height: 24.h,
                width: 24.w,
              ),
            ),
        showLogoOnLeft
            ? GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
              child: SvgPicture.asset(
                MyIcons.arrowback,
                height: 24.h,
                width: 24.w,
              ),
            )
            : Image(image: AssetImage(MyImages.appicon), height: 60.h),
      ],
    );
  }
}
