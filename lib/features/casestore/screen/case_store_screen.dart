import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/widgets/case_store_filter/case_store_filter_drawer.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/game_card.dart';
import 'package:alqadiya_game/widgets/game_card_shimmer.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CaseStoreScreen extends StatefulWidget {
  CaseStoreScreen({super.key});

  @override
  State<CaseStoreScreen> createState() => _CaseStoreScreenState();
}

class _CaseStoreScreenState extends State<CaseStoreScreen> {
  final filterController = Get.put(GameController());
  final tooltipController = JustTheController();
  final isFilterDrawerOpen = false.obs;
  late final GameController gameController;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Access GameController to trigger initialization and getGamesList() API call
    gameController = Get.find<GameController>();

    // Add listener to scroll controller
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        gameController.getGamesList(isLoadMore: true);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final preferences = Get.find<Preferences>();
      final hasShownTip = preferences.getBool(AppStrings.hasShownCategoryTip) ?? false;

      if (!hasShownTip) {
        tooltipController.showTooltip();
        preferences.setBool(AppStrings.hasShownCategoryTip, true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
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
                    title: Row(
                      children: [
                        Text(
                          'Case Store'.tr,
                          style: AppTextStyles.heading1().copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Container(
                          width: 1.w,
                          height: 20.h,
                          color: MyColors.white.withValues(alpha: 0.2),
                        ),
                        SizedBox(width: 5.w),
                        JustTheTooltip(
                          controller: tooltipController,
                          tailBuilder: (tip, point2, point3) {
                            const tailWidth = 10;
                            return Path()
                              ..moveTo(tip.dx, tip.dy)
                              ..lineTo(tip.dx - tailWidth / 2, point2.dy)
                              ..lineTo(tip.dx + tailWidth / 2, point3.dy)
                              ..close();
                          },

                          backgroundColor: Colors.white,
                          content: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.sp,
                              vertical: 3.sp,
                            ),
                            child: Text(
                              'Sort by category',
                              style: TextStyle(color: MyColors.black),
                            ),
                          ),
                          child: PopupMenuButton<String>(
                            offset: Offset(0, 30.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            color: MyColors.backgroundColor,
                            onSelected: (value) {
                              gameController.setCategory(value);
                            },
                            itemBuilder:
                                (context) => [
                                  PopupMenuItem(
                                    value: 'Recent Cases',
                                    child: Text(
                                      'Recent Cases',
                                      style: AppTextStyles.labelMedium14()
                                          .copyWith(
                                            color: MyColors.white,
                                            fontSize: 6.sp,
                                          ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'My Games',
                                    child: Text(
                                      'My Games',
                                      style: AppTextStyles.labelMedium14()
                                          .copyWith(
                                            color: MyColors.white,
                                            fontSize: 6.sp,
                                          ),
                                    ),
                                  ),
                                ],
                            child: Row(
                              children: [
                                Obx(
                                  () => Text(
                                    gameController.selectedCategory.value,
                                    style: AppTextStyles.heading1().copyWith(
                                      fontSize: 7.sp,
                                      color: MyColors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 15.sp,
                                  color: MyColors.white.withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    actionButtons: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            isFilterDrawerOpen.toggle();
                          },
                          child: SvgPicture.asset(MyIcons.filter),
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

                Expanded(
                  child: Obx(() {
                    if (gameController.isLoading.value &&
                        gameController.gamesList.isEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return GameCardShimmer();
                        },
                      );
                    }

                    if (!gameController.isLoading.value &&
                        gameController.gamesList.isEmpty) {
                      return Center(
                        child: Text(
                          'No games available'.tr,
                          style: AppTextStyles.bodyTextRegular16().copyWith(
                            color: MyColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount:
                          gameController.isMoreLoading.value
                              ? gameController.gamesList.length + 1
                              : gameController.gamesList.length,
                      itemBuilder: (context, index) {
                        if (index < gameController.gamesList.length) {
                          final game = gameController.gamesList[index];
                          return GameCard(game: game);
                        } else {
                          return GameCardShimmer();
                        }
                      },
                    );
                  }),
                ),
              ],
            ),

            // Filter Drawer Overlay
            Obx(
              () =>
                  isFilterDrawerOpen.value
                      ? GestureDetector(
                        onTap: () => isFilterDrawerOpen.toggle(),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      )
                      : SizedBox.shrink(),
            ),

            // Filter Drawer
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                right: isFilterDrawerOpen.value ? 0 : -300.w,
                top: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: CaseStoreFilterDrawer(
                    onCloseTap: () => isFilterDrawerOpen.value = false,
                    onApplyTap: () => isFilterDrawerOpen.value = false,
                    onCancelTap: () => isFilterDrawerOpen.value = false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
