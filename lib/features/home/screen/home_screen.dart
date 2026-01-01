import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/auth/controller/user_controller.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/localization_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/home/controller/home_controller.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/core/constants/app_strings.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<HomeController>();
  late final UserController userController;

  @override
  void initState() {
    rotateScreen();
    userController = Get.find<UserController>();
    super.initState();
  }

  void rotateScreen() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final prefs = Get.find<Preferences>();
    final isGuest = prefs.getBool(AppStrings.isGuest) ?? false;

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        imageUrl: "https://picsum.photos/200",
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              child: Column(
                children: [
                  // Top Bar
                  HomeHeader(
                    onChromTap: () {},
                    actionButtons: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.notificationsListScreen);
                          },
                          child: SvgPicture.asset(MyIcons.notification),
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: controller.toggleDrawer,
                          child: SvgPicture.asset(MyIcons.menu),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(MyImages.appicon),
                          height: screenHeight * 0.62,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 30.w),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.caseStoreScreen);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                MyIcons.casestore,
                                height: screenHeight * 0.2,
                              ),
                              Text(
                                'Case Store'.tr,
                                style: AppTextStyles.heading1().copyWith(
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isGuest) ...[
                          SizedBox(width: 20.w),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.joinGameScreen);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                SvgPicture.asset(
                                  MyIcons.joingame,
                                  height: screenHeight * 0.2,
                                ),
                                Text(
                                  'Join the Game'.tr,
                                  style: AppTextStyles.heading1().copyWith(
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  LocalizationFooter(showDividerInColumn: true).buildDivider(),
                  LocalizationFooter(usePositioned: true),
                ],
              ),
            ),

            // Drawer Overlay
            Obx(
              () =>
                  controller.isDrawerOpen.value
                      ? GestureDetector(
                        onTap: () => controller.toggleDrawer(),
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
                right: controller.isDrawerOpen.value ? 0 : -250.w,
                top: 0,
                bottom: 0,
                child: SingleChildScrollView(child: controller.buildDrawer()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
