import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/features/game/controller/game_result_provider.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/game_footer.dart';
import 'package:alqadiya_game/widgets/gradient_box_border.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GameResultSummaryScreen extends StatelessWidget {
  const GameResultSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize game result controller
    final gameResultController = Get.find<GameResultController>();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        imageUrl: "https://picsum.photos/200",
        body: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 5.sp),
              child: HomeHeader(
                onChromTap: () {},
                title: Text(
                  'Game Result Summary'.tr,
                  style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                ),
                actionButtons: GestureDetector(
                  onTap: () => Get.back(),
                  child: SvgPicture.asset(MyIcons.arrowbackrounded),
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Team Result Card
                    Expanded(
                      child: _buildTeamResultCard(
                        context,
                        gameResultController.teamResults[0],
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: _buildTeamResultCard(
                        context,
                        gameResultController.teamResults[1],
                      ),
                    ),
                    SizedBox(width: 6.w),

                    // Right Side - Team Card, Winner & Actions
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 6.w,
                        ),
                        decoration: BoxDecoration(
                          color: MyColors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Winner Announcement
                            Container(
                              // padding: EdgeInsets.only(left: 5.w),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: MyColors.black.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(80.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'The winner'.tr,
                                    style: AppTextStyles.heading2().copyWith(
                                      fontSize: 6.sp,
                                      color: MyColors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' ${gameResultController.winnerTeam}'.tr,
                                    style: AppTextStyles.heading1().copyWith(
                                      fontSize: 8.sp,
                                      color: MyColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            // Share result button
                            GestureDetector(
                              onTap: () {
                                // Share result action
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: MyColors.redButtonColor,
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Share result'.tr,
                                      style: AppTextStyles.heading2().copyWith(
                                        fontSize: 6.sp,
                                        color: MyColors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),

                                    Icon(
                                      Icons.share,
                                      size: 14.sp,
                                      color: MyColors.brightRedColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Back to Main Page button
                            GestureDetector(
                              onTap: () {
                                Get.offAllNamed(AppRoutes.homescreen);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: MyColors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(80.r),
                                ),
                                child: Center(
                                  child: Text(
                                    'Back to the Main Page'.tr,
                                    style: AppTextStyles.heading1().copyWith(
                                      fontSize: 6.sp,
                                      color: MyColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 5.sp),
              child: GameFooter(onGameResultTap: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamResultCard(
    BuildContext context,
    Map<String, dynamic> result,
  ) {
    final players = result['players'] as List<Map<String, dynamic>>;
    final isCorrect = result['isCorrect'] as bool;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: MyColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team Info Row
          Row(
            children: [
              // Player avatars - overlapping
              SizedBox(
                width: (15.w * players.length) - ((players.length - 1) * 8.w),
                height: 15.w,
                child: Stack(
                  children:
                      players.asMap().entries.map((entry) {
                        final index = entry.key;
                        final player = entry.value;
                        final isLast = index == players.length - 1;
                        return Positioned(
                          left: index * (15.w - 8.w),
                          child: Stack(
                            children: [
                              Container(
                                width: 15.w,
                                height: 15.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.r),
                                  child: CachedNetworkImage(
                                    imageUrl: player['avatar'] as String,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => Container(
                                          color: MyColors.darkBlueColor,
                                        ),
                                    errorWidget:
                                        (context, url, error) => Container(
                                          color: MyColors.darkBlueColor,
                                          child: Icon(
                                            Icons.person,
                                            size: 12.sp,
                                            color: MyColors.white.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              // Green checkmark - only on rightmost member
                              if (isLast)
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: BoxDecoration(
                                      color: MyColors.greenColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 6.sp,
                                      color: MyColors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),

              SizedBox(width: 8.w),

              Text(
                result['name'] as String,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.heading1().copyWith(
                  fontSize: 7.sp,
                  color: MyColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Container(
          //   padding: EdgeInsets.all(3.sp),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(20.r),
          //     color:
          //         isCorrect
          //             ? MyColors.greenColor.withValues(alpha: 0.1)
          //             : MyColors.redButtonColor.withValues(alpha: 0.1),
          //     border: GradientBoxBorder(
          //       gradient: LinearGradient(
          //         begin: AlignmentGeometry.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors:
          //             isCorrect
          //                 ? [
          //                   MyColors.greenColor.withValues(alpha: 0.1),
          //                   MyColors.greenColor,
          //                 ]
          //                 : [
          //                   MyColors.redButtonColor.withValues(alpha: 0.1),
          //                   MyColors.redButtonColor,
          //                 ],
          //       ),
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       ClipRRect(
          //         borderRadius: BorderRadius.circular(10.r),
          //         child: CachedNetworkImage(
          //           imageUrl: result['suspectImage'] as String,
          //           height: 85.h,
          //           width: 32.w,
          //           fit: BoxFit.cover,
          //           placeholder:
          //               (context, url) => Container(
          //                 color: MyColors.darkBlueColor,
          //                 height: 70.h,
          //                 child: Center(
          //                   child: CircularProgressIndicator(
          //                     valueColor: AlwaysStoppedAnimation<Color>(
          //                       MyColors.greenColor,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //           errorWidget:
          //               (context, url, error) => Container(
          //                 color: MyColors.darkBlueColor,
          //                 height: 70.h,
          //                 child: Icon(
          //                   Icons.person,
          //                   size: 50.sp,
          //                   color: MyColors.white.withValues(alpha: 0.5),
          //                 ),
          //               ),
          //         ),
          //       ),
          //       SizedBox(width: 3.w),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           // Suspect chosen text
          //           Text(
          //             'Suspect choosen'.tr,
          //             overflow: TextOverflow.ellipsis,
          //             style: AppTextStyles.heading2().copyWith(
          //               fontSize: 7.sp,
          //               color: MyColors.white,
          //             ),
          //           ),
          //           SizedBox(height: 8.h),
          //           // Suspect name
          //           Row(
          //             children: [
          //               Text(
          //                 result['suspectName'] as String,
          //                 overflow: TextOverflow.ellipsis,

          //                 style: AppTextStyles.heading1().copyWith(
          //                   fontSize: 7.sp,
          //                   color: MyColors.white,
          //                 ),
          //               ),
          //               SizedBox(width: 5.w),
          //               SvgPicture.asset(
          //                 isCorrect ? MyIcons.green_check : MyIcons.brown_close,
          //                 height: 25.h,
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          // SizedBox(height: 5.h),

          // Metrics
          _buildMetricRow('Total score', '${result['totalScore']}'),
          SizedBox(height: 3.h),
          _buildMetricRow('Time taken', result['timeTaken'] as String),
          SizedBox(height: 3.h),
          _buildMetricRow('Accuracy', '${result['accuracy']}%'),
          SizedBox(height: 3.h),
          _buildMetricRow('Hints used', '${result['hintsUsed']}'),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.tr,
          style: AppTextStyles.heading2().copyWith(
            fontSize: 6.sp,
            color: MyColors.white.withValues(alpha: 0.5),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.heading1().copyWith(
            fontSize: 6.sp,
            color: MyColors.white,
          ),
        ),
      ],
    );
  }
}
