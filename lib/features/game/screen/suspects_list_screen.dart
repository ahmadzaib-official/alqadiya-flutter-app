import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/game_footer.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/features/game/screen/suspect_detail_screen.dart';
import 'package:alqadiya_game/features/game/controller/suspect_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:alqadiya_game/features/game/controller/game_timer_controller.dart';

class SuspectsListScreen extends StatefulWidget {
  const SuspectsListScreen({super.key});

  @override
  State<SuspectsListScreen> createState() => _SuspectsListScreenState();
}

class _SuspectsListScreenState extends State<SuspectsListScreen> {
  late final GameTimerController timerController;
  final suspectController = Get.find<SuspectController>();
  final gameController = Get.find<GameController>();

  @override
  void initState() {
    super.initState();
    // Get the existing timer controller (should already be initialized from game_screen)
    // If not found, create it (fallback scenario)
    if (Get.isRegistered<GameTimerController>()) {
      timerController = Get.find<GameTimerController>();
    } else {
      timerController = Get.put(GameTimerController(), permanent: true);
      timerController.startTimer();
    }
    
    // Fetch suspects from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameId = gameController.gameDetail.value?.id ?? 
                     gameController.gameSession.value?.gameId;
      if (gameId != null && gameId.isNotEmpty) {
        suspectController.getSuspectsByGame(gameId: gameId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                title: Row(
                  children: [
                    Text(
                      'List of suspects'.tr,
                      style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      'Timer '.tr,
                      style: AppTextStyles.heading1().copyWith(
                        fontSize: 10.sp,
                        color: MyColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    Obx(
                      () => Text(
                        timerController.timerText.value,
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                actionButtons: GestureDetector(
                  onTap: () => Get.back(),
                  child: SvgPicture.asset(MyIcons.arrowbackrounded),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Main Content - Suspects List
            Expanded(child: _buildSuspectsList()),

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

  Widget _buildSuspectsList() {
    // return ListView.builder(
    //   scrollDirection: Axis.horizontal,
    //   padding: EdgeInsets.symmetric(horizontal: 20.w),
    //   itemCount: suspects.length,
    //   itemBuilder: (context, index) {
    //     final suspect = suspects[index];
    //     return GestureDetector(
    //       onTap: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => const SuspectDetailScreen(),
    //           ),
    //         );
    //       },
    //       child: Container(
    //         margin: EdgeInsets.only(right: 15.w),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             // Suspect Image
    //             Container(
    //               width: 40.w,
    //               height: 40.w,
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(12.r),
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: Colors.black.withValues(alpha: 0.3),
    //                     blurRadius: 8,
    //                     offset: const Offset(0, 4),
    //                   ),
    //                 ],
    //               ),
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(12.r),
    //                 child: CachedNetworkImage(
    //                   imageUrl: suspect['imageUrl'] as String,
    //                   fit: BoxFit.cover,
    //                   placeholder:
    //                       (context, url) => Container(
    //                         color: MyColors.darkBlueColor,
    //                         child: Center(
    //                           child: CircularProgressIndicator(
    //                             color: MyColors.redButtonColor,
    //                             strokeWidth: 2,
    //                           ),
    //                         ),
    //                       ),
    //                   errorWidget:
    //                       (context, url, error) => Container(
    //                         color: MyColors.darkBlueColor,
    //                         child: Icon(
    //                           Icons.person,
    //                           color: MyColors.white.withValues(alpha: 0.5),
    //                           size: 40.sp,
    //                         ),
    //                       ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: 10.h),
    //             // Suspect Name
    //             Text(
    //               suspect['name'] as String,
    //               style: TextStyle(
    //                 fontSize: 6.sp,
    //                 color: MyColors.white,
    //                 fontWeight: FontWeight.w500,
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
    return Obx(
      () {
        if (suspectController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: MyColors.redButtonColor,
            ),
          );
        }
        
        if (suspectController.suspects.isEmpty) {
          return Center(
            child: Text(
              'No suspects available'.tr,
              style: AppTextStyles.heading1().copyWith(
                fontSize: 8.sp,
                color: MyColors.white.withValues(alpha: 0.5),
              ),
            ),
          );
        }
        
        final suspects = suspectController.suspects;

        return Center(
          child: SizedBox(
            height: 0.5.sh, // enough to fit image + name
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: suspects.length,
              itemBuilder: (context, index) {
                final suspect = suspects[index];
                return GestureDetector(
                  onTap: () {
                    // Fetch suspect details and navigate
                    suspectController.getSuspectById(suspectId: suspect.id ?? '');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuspectDetailScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Suspect Image
                        Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: CachedNetworkImage(
                              imageUrl: suspect.profileImageURL ?? 
                                       suspect.profileImage ?? 
                                       'https://picsum.photos/200',
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Container(
                                    color: MyColors.darkBlueColor,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: MyColors.redButtonColor,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Container(
                                    color: MyColors.darkBlueColor,
                                    child: Icon(
                                      Icons.person,
                                      color: MyColors.white.withValues(alpha: 0.5),
                                      size: 40.sp,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          suspect.nameEn ?? suspect.nameAr ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 6.sp,
                            color: MyColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
