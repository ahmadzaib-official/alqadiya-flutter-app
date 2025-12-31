import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/controller/evidence_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_timer_controller.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/game_footer.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class EvidenceListScreen extends StatefulWidget {
  const EvidenceListScreen({super.key});

  @override
  State<EvidenceListScreen> createState() => _EvidenceListScreenState();
}

class _EvidenceListScreenState extends State<EvidenceListScreen> {

  @override
  void initState() {
    super.initState();
    final evidenceController = Get.find<EvidenceController>();
    final gameController = Get.find<GameController>();
    
    // Fetch evidences if gameId is available
    final gameId = gameController.gameDetail.value?.id ?? 
                   gameController.gameSession.value?.gameId;
    if (gameId != null) {
      evidenceController.getEvidencesByGame(gameId: gameId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the existing timer controller (should already be initialized from game_screen)
    // If not found, create it (fallback scenario)
    final timerController =
        Get.isRegistered<GameTimerController>()
              ? Get.find<GameTimerController>()
              : Get.put(GameTimerController(), permanent: true)
          ..startTimer();
    
    final evidenceController = Get.find<EvidenceController>();
    final gameController = Get.find<GameController>();
    
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Obx(
        () => GameBackground(
          isPurchased: true,
          imageUrl: gameController.gameDetail.value?.coverImageUrl ?? 
                   gameController.gameDetail.value?.coverImage ?? 
                   "https://picsum.photos/200",
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
                        gameController.gameDetail.value?.title ?? 'List of evidence'.tr,
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

              SizedBox(height: 5.h),

              // Main Content - Evidence List
              Expanded(
                child: Obx(() {
                  if (evidenceController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: MyColors.redButtonColor,
                      ),
                    );
                  }
                  
                  if (evidenceController.evidences.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage(MyImages.mail)),
                          SizedBox(height: 20.h),
                          Text(
                            'No evidence available'.tr,
                            style: AppTextStyles.heading1().copyWith(
                              fontSize: 10.sp,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    itemCount: evidenceController.evidences.length,
                    itemBuilder: (context, index) {
                      final evidence = evidenceController.evidences[index];
                      return GestureDetector(
                        onTap: () {
                          evidenceController.getEvidenceById(evidenceId: evidence.id ?? '');
                          Get.toNamed(
                            AppRoutes.clueDetailScreen,
                            arguments: {'evidenceId': evidence.id ?? ''},
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: MyColors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: MyColors.redButtonColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Evidence Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: CachedNetworkImage(
                                  imageUrl: evidence.profileImageURL ?? 
                                           evidence.profileImage ?? 
                                           "https://picsum.photos/200",
                                  width: 60.w,
                                  height: 60.h,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 60.w,
                                    height: 60.h,
                                    color: MyColors.darkBlueColor,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: MyColors.redButtonColor,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 60.w,
                                    height: 60.h,
                                    color: MyColors.darkBlueColor,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: MyColors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              // Evidence Name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      evidence.evidenceName ?? 'Evidence',
                                      style: AppTextStyles.heading1().copyWith(
                                        fontSize: 8.sp,
                                        color: MyColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (evidence.description != null) ...[
                                      SizedBox(height: 4.h),
                                      Text(
                                        evidence.description!,
                                        style: AppTextStyles.heading2().copyWith(
                                          fontSize: 6.sp,
                                          color: MyColors.white.withValues(alpha: 0.7),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              // Arrow Icon
                              Icon(
                                Icons.arrow_forward_ios,
                                color: MyColors.white,
                                size: 16.sp,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              // Footer
              Padding(
                padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 5.sp),
                child: GameFooter(onGameResultTap: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
