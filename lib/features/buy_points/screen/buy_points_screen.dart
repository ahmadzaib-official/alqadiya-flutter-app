import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/buy_points/controller/buy_points_provider.dart';
import 'package:alqadiya_game/features/buy_points/model/package_model.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/localization_footer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BuyPointsScreen extends StatelessWidget {
  const BuyPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize buy points controller
    final buyPointsController = Get.find<BuyPointsController>();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        imageUrl: "https://picsum.photos/200",
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
          child: Column(
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back arrow
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset(MyIcons.arrowbackrounded),
                  ),
                  // Title
                  Text(
                    'Buy points'.tr,
                    style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(MyIcons.chromecast),
                      ),
                      SizedBox(width: 5.w),

                      // Avatar
                      CircleAvatar(
                        backgroundColor: MyColors.redButtonColor,
                        backgroundImage: CachedNetworkImageProvider(
                          "https://picsum.photos/200",
                        ),
                        radius: 9.sp,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Divider(color: MyColors.white.withValues(alpha: 0.1)),
              SizedBox(height: 5.h),

              // Main Content - Points Packages
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 6.sp,
                    horizontal: 20.sp,
                  ),
                  child: Obx(() {
                    if (buyPointsController.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: MyColors.redButtonColor,
                        ),
                      );
                    }

                    if (buyPointsController.pointPackages.isEmpty) {
                      return Center(
                        child: Text(
                          "No packages available",
                          style: AppTextStyles.heading2().copyWith(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            buyPointsController.pointPackages
                                .asMap()
                                .entries
                                .map((entry) {
                                  final index = entry.key;
                                  final package = entry.value;

                                  return Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: SizedBox(
                                      width: 0.25.sw,
                                      child: _buildPointPackageCard(
                                        context,
                                        buyPointsController,
                                        package,
                                        index,
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                      ),
                    );
                  }),
                ),
              ),

              // Footer - Language switch
              SizedBox(height: 5.h),
              LocalizationFooter(showDividerInColumn: true).buildDivider(),
              LocalizationFooter(usePositioned: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointPackageCard(
    BuildContext context,
    BuyPointsController controller,
    PackageModel package,
    int index,
  ) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: MyColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Points amount
          Text(
            '${package.points} Points',
            style: AppTextStyles.heading1().copyWith(
              fontSize: 10.sp,
              color: MyColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 15.h),
          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Price '.tr,
                style: AppTextStyles.heading2().copyWith(
                  fontSize: 7.sp,
                  color: MyColors.white.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(width: 2.w),

              SizedBox(
                height: 20.h,
                child: VerticalDivider(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              SizedBox(width: 2.w),

              Text(
                package.price.toString(),
                style: AppTextStyles.heading1().copyWith(
                  fontSize: 7.sp,
                  color: MyColors.white,
                ),
              ),
              Text(
                ' KD',
                style: AppTextStyles.heading2().copyWith(
                  fontSize: 6.sp,
                  color: MyColors.white,
                ),
              ),
            ],
          ),

          SizedBox(height: 15.h),
          // Buy points button
          GestureDetector(
            onTap: () {
              goToPaymentScreen(package);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: MyColors.redButtonColor,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 6),
                  Text(
                    'Buy points'.tr,
                    style: AppTextStyles.heading2().copyWith(
                      fontSize: 6.sp,
                      color: MyColors.white,
                    ),
                  ),
                  Spacer(flex: 2),

                  SvgPicture.asset(
                    MyIcons.arrow_right,
                    colorFilter: ColorFilter.mode(
                      MyColors.brightRedColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goToPaymentScreen(PackageModel package) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Future.delayed(Duration(milliseconds: 60), () {
      Get.toNamed(
        AppRoutes.paymentScreen,
        arguments: {
          'id': package.id,
          'points': package.points,
          'price': package.price,
        },
      );
    });
  }
}
