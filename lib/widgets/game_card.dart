import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/model/game_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class GameCard extends StatelessWidget {
  final GameModel game;
  final Color buttonColor;
  const GameCard({
    Key? key,
    required this.game,
    this.buttonColor = MyColors.redButtonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Helper function to get difficulty color based on difficulty string
    Color _getDifficultyColor(String? difficulty) {
      if (difficulty == null) return MyColors.redButtonColor;

      final difficultyLower = difficulty.toLowerCase();
      if (difficultyLower.contains('beginner') ||
          difficultyLower.contains('easy')) {
        return MyColors.blue; // 🟢 Beginner
      } else if (difficultyLower.contains('intermediate') ||
          difficultyLower.contains('medium')) {
        return MyColors.redButtonColor; // 🟠 Intermediate
      } else if (difficultyLower.contains('difficult') ||
          difficultyLower.contains('hard') ||
          difficultyLower.contains('expert')) {
        return MyColors.purple; // 🔴 Difficult
      }
      return MyColors.redButtonColor; // Default
    }

    final Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.caseDetailScreen,
          arguments: {"gameId": game.id ?? ''},
        );
      },
      child: Container(
        width: size.width * 0.22,
        margin: EdgeInsets.only(left: 15.w),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                // Image with rounded top corners
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(40.r)),
                  child: CachedNetworkImage(
                    imageUrl: game.coverImageUrl ?? game.coverImage ?? '',
                    width: double.infinity,
                    height: size.height * 0.34,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Shimmer.fromColors(
                          baseColor: MyColors.backgroundColor.withValues(
                            alpha: 0.3,
                          ),
                          highlightColor: MyColors.white.withValues(alpha: 0.1),

                          child: Container(
                            width: double.infinity,
                            height: size.height * 0.34,
                            color: Colors.grey,
                          ),
                        ),
                    errorWidget: (context, url, error) {
                      return Container(
                        width: double.infinity,
                        height: size.height * 0.34,
                        color: const Color(0xFFE8D5C4),
                        child: const Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                // Difficulty Badge
                Positioned(
                  top: 20.sp,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.sp,
                      vertical: 3.sp,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(game.difficulty),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        bottomLeft: Radius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      game.difficulty ?? 'Unknown'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 6.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (!game.isPurchased!)
                  Positioned(
                    top: 20.sp,
                    left: 3.w,
                    child: Opacity(
                      opacity: 0.8,
                      child: SvgPicture.asset(MyIcons.lockrounded),
                    ),
                  ),
              ],
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(5.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    game.title ?? 'Unknown Game'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5.h),

                  // Description
                  // Text(
                  //   game.description ?? 'No description available',
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(color: Colors.white, fontSize: 6.sp),
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(
                    height: 6.sp * 1.4 * 2,
                    child: Text(
                      game.description ?? 'No description available'.tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 6.sp,
                        height: 1.4, // Line height multiplier
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Buy Button
                  if (game.isPurchased! && !game.isPlayed!) ...[
                    Container(
                      width: 60.w,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: MyColors.greenColor,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(flex: 6),
                          Text(
                            'Start Play'.tr,
                            style: TextStyle(
                              fontSize: 6.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),

                          Spacer(flex: 2),

                          Icon(
                            Icons.arrow_forward_ios,
                            size: 8.sp,
                            color: MyColors.darkGreenColor,
                          ),
                          Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ] else if (game.isPlayed! && game.isPurchased!) ...[
                    Container(
                      width: 60.w,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: MyColors.backgroundColor,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(flex: 6),
                          Text(
                            'Played'.tr,
                            style: TextStyle(
                              fontSize: 6.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),

                          Spacer(flex: 2),

                          Icon(
                            Icons.arrow_forward_ios,
                            size: 8.sp,
                            color: MyColors.darkBlueColor,
                          ),
                          Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: buttonColor,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(flex: 6),

                          Text(
                            'Buy'.tr,
                            style: TextStyle(
                              fontSize: 6.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 1,
                            height: 20,
                            color: MyColors.brightRedColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${game.costPoints} ',
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Points'.tr,
                            style: TextStyle(
                              fontSize: 6.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(flex: 2),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 8.sp,
                            color: MyColors.brightRedColor,
                          ),
                          Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
