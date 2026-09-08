import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/features/game/controller/game_result_provider.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/game_footer.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/gradient_box_border.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GameResultSummaryScreen extends StatefulWidget {
  const GameResultSummaryScreen({super.key});

  @override
  State<GameResultSummaryScreen> createState() =>
      _GameResultSummaryScreenState();
}

class _GameResultSummaryScreenState extends State<GameResultSummaryScreen> {
  bool _isSharing = false;
  DateTime? _lastShareTime; // Add debounce timer
  Timer? _pollingTimer;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final gameResultController = Get.find<GameResultController>();
    final gameController = Get.find<GameController>();
    final sessionId = gameController.gameSession.value?.id;

    if (sessionId != null) {
      gameResultController.getGameResult(sessionId: sessionId, silent: false);
      _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        gameResultController.getGameResult(sessionId: sessionId, silent: true);
      });
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _shareResult({Rect? sharePositionOrigin}) async {
    // Double check to prevent multiple calls
    if (_isSharing) return;

    // Debounce check - prevent rapid fire clicks
    final now = DateTime.now();
    if (_lastShareTime != null &&
        now.difference(_lastShareTime!).inSeconds < 2) {
      print('Share blocked - too soon since last share');
      return;
    }

    _lastShareTime = now;

    if (!mounted) return;

    setState(() {
      _isSharing = true;
    });

    try {
      RenderRepaintBoundary? boundary =
          _globalKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        print('Boundary is null');
        return;
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // Write to temp directory for iOS compatibility
        final directory = await getTemporaryDirectory();
        final imagePath =
            '${directory.path}/game_result_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = io.File(imagePath);
        await imageFile.writeAsBytes(pngBytes);

        final XFile file = XFile(imagePath);

        // ignore: deprecated_member_use
        await Share.shareXFiles(
          [file],
          text: 'Check out my game result on Alqadiya!'.tr,
          sharePositionOrigin: sharePositionOrigin,
        );
      }
    } catch (e) {
      print('Error sharing result: $e');
    } finally {
      // Wait for share sheet to close before resetting
      await Future.delayed(Duration(milliseconds: 1500));
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Widget _buildShareButton({required bool isSoloMode}) {
    return IgnorePointer(
      ignoring: _isSharing,
      child: Opacity(
        opacity: _isSharing ? 0.5 : 1.0,
        child: GestureDetector(
          onTap:
              _isSharing
                  ? null
                  : () async {
                    await _shareResult();
                  },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: isSoloMode ? 10.h : 12.h),
            decoration: BoxDecoration(
              color: MyColors.redButtonColor,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isSharing)
                  SizedBox(
                    width: 14.sp,
                    height: 14.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
                    ),
                  )
                else
                  Text(
                    'Share result'.tr,
                    style: AppTextStyles.heading2().copyWith(
                      fontSize: 6.sp,
                      color: MyColors.white,
                    ),
                  ),
                SizedBox(width: 8.w),
                Icon(Icons.share, size: 14.sp, color: MyColors.brightRedColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameResultController = Get.find<GameResultController>();
    final gameController = Get.find<GameController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.offNamedUntil(AppRoutes.homescreen, (route) => false);
      },
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: RepaintBoundary(
          key: _globalKey,
          child: GameBackground(
            imageUrl: "https://picsum.photos/200",
            body: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.sp,
                    right: 10.sp,
                    top: 5.sp,
                  ),
                  child: HomeHeader(
                    title: Text(
                      'Game Result Summary'.tr,
                      style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                    ),
                    actionButtons: GestureDetector(
                      onTap:
                          () => Get.offNamedUntil(
                            AppRoutes.homescreen,
                            (route) => false,
                          ),
                      child: SvgPicture.asset(MyIcons.arrowbackrounded),
                    ),
                  ),
                ),

                // Main Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Obx(() {
                      final gameResult = gameResultController.gameResult.value;
                      final isLoading = gameResultController.isLoading.value;

                      // Prefer data-driven mode detection:
                      // - If multiple teams exist -> team mode (scoreboard with 2 cards)
                      // - Else fall back to solo mode checks
                      final isTeamMode = gameResultController.isTeamMode;
                      final isSoloMode =
                          !isTeamMode &&
                          (gameController.gameSession.value?.mode == 'solo' ||
                              gameResultController.isSoloModeFromData);

                      if (isLoading) {
                        return Center(
                          child: Text(
                            'Loading results...'.tr,
                            style: AppTextStyles.heading1().copyWith(
                              fontSize: 8.sp,
                              color: MyColors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        );
                      }

                      if (gameResult == null) {
                        return Center(
                          child: Text(
                            'No results available'.tr,
                            style: AppTextStyles.heading1().copyWith(
                              fontSize: 8.sp,
                              color: MyColors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        );
                      }

                      if (isTeamMode) {
                        final teamResults = gameResultController.teamResults;
                        if (teamResults.isEmpty) {
                          return Center(
                            child: Text(
                              'No team results available'.tr,
                              style: AppTextStyles.heading1().copyWith(
                                fontSize: 8.sp,
                                color: MyColors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (teamResults.length > 0)
                              Expanded(
                                child: _buildTeamResultCard(
                                  context,
                                  teamResults[0],
                                  isWinner: _isWinningTeam(
                                    teamResults[0]['name'],
                                  ),
                                ),
                              ),
                            if (teamResults.length > 1) SizedBox(width: 6.w),
                            if (teamResults.length > 1)
                              Expanded(
                                child: _buildTeamResultCard(
                                  context,
                                  teamResults[1],
                                  isWinner: _isWinningTeam(
                                    teamResults[1]['name'],
                                  ),
                                ),
                              ),
                            if (teamResults.length > 1) SizedBox(width: 6.w),
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
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: MyColors.black.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          80.r,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'The winner'.tr,
                                            style: AppTextStyles.heading2()
                                                .copyWith(
                                                  fontSize: 6.sp,
                                                  color: MyColors.white
                                                      .withValues(alpha: 0.5),
                                                ),
                                          ),
                                          Text(
                                            ' ${gameResultController.winnerTeamName ?? ''}',
                                            style: AppTextStyles.heading1()
                                                .copyWith(
                                                  fontSize: 8.sp,
                                                  color: MyColors.white,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    _buildShareButton(isSoloMode: false),
                                    SizedBox(height: 16.h),
                                    GestureDetector(
                                      onTap: () {
                                        Get.offAllNamed(AppRoutes.homescreen);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: MyColors.white.withValues(
                                            alpha: 0.05,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            80.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Back to the Main Page'.tr,
                                            style: AppTextStyles.heading1()
                                                .copyWith(
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
                        );
                      } else if (isSoloMode) {
                        final soloPlayerResult =
                            gameResultController.soloPlayerResult;
                        if (soloPlayerResult == null) {
                          return Center(
                            child: Text(
                              'No solo player results available'.tr,
                              style: AppTextStyles.heading1().copyWith(
                                fontSize: 8.sp,
                                color: MyColors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildSoloPlayerResultCard(
                                context,
                                soloPlayerResult,
                              ),
                            ),
                            SizedBox(width: 6.w),
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
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: MyColors.black.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          80.r,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Game Completed'.tr,
                                            style: AppTextStyles.heading1()
                                                .copyWith(
                                                  fontSize: 8.sp,
                                                  color: MyColors.white,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    _buildShareButton(isSoloMode: true),
                                    SizedBox(height: 16.h),
                                    GestureDetector(
                                      onTap: () {
                                        Get.offAllNamed(AppRoutes.homescreen);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: MyColors.white.withValues(
                                            alpha: 0.05,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            80.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Back to the Main Page'.tr,
                                            style: AppTextStyles.heading1()
                                                .copyWith(
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
                        );
                      } else {
                        final teamResults = gameResultController.teamResults;
                        if (teamResults.isEmpty) {
                          return Center(
                            child: Text(
                              'No team results available'.tr,
                              style: AppTextStyles.heading1().copyWith(
                                fontSize: 8.sp,
                                color: MyColors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        }

                        // Fallback: if neither team nor solo mode detected, show a simple message
                        return Center(
                          child: Text(
                            'No results available'.tr,
                            style: AppTextStyles.heading1().copyWith(
                              fontSize: 8.sp,
                              color: MyColors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                ),

                // Footer
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.sp,
                    right: 10.sp,
                    bottom: 5.sp,
                  ),
                  child: GameFooter(onGameResultTap: () {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamResultCard(
    BuildContext context,
    Map<String, dynamic> result, {
    bool isWinner = false,
  }) {
    final playersData = result['players'];
    final List<Map<String, dynamic>> players =
        playersData is List
            ? playersData
                .map(
                  (item) =>
                      item is Map<String, dynamic>
                          ? item
                          : Map<String, dynamic>.from(item as Map),
                )
                .toList()
            : <Map<String, dynamic>>[];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: MyColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: GradientBoxBorder(
          width: 2.0,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isWinner
                    ? [
                      MyColors.greenColor.withValues(alpha: 0.1),
                      MyColors.greenColor,
                    ]
                    : [
                      MyColors.redButtonColor.withValues(alpha: 0.1),
                      MyColors.redButtonColor,
                    ],
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: (15.w * players.length) - ((players.length - 1) * 8.w),
                height: 15.w,
                child: Stack(
                  children:
                      players.asMap().entries.map((entry) {
                        final index = entry.key;
                        final player = entry.value;
                        final isLeader = player['isLeader'] as bool? ?? false;
                        return Positioned(
                          left: index * (15.w - 8.w),
                          child: Stack(
                            children: [
                              Container(
                                width: 15.w,
                                height: 15.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyColors.darkBlueColor,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.r),
                                  child:
                                      (player['avatar'] as String? ?? '')
                                              .isNotEmpty
                                          ? CachedNetworkImage(
                                            imageUrl:
                                                player['avatar'] as String,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                (context, url) => Container(
                                                  color: MyColors.darkBlueColor,
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 12.sp,
                                                    color: MyColors.white
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Container(
                                                  color: MyColors.darkBlueColor,
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 12.sp,
                                                    color: MyColors.white
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                ),
                                          )
                                          : Container(
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
                              if (isLeader)
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
          _buildMetricRow('Total score'.tr, '${result['totalScore']}'),
          SizedBox(height: 3.h),
          _buildMetricRow('Time taken'.tr, result['timeTaken'] as String),
          SizedBox(height: 3.h),
          _buildMetricRow('Accuracy'.tr, '${result['accuracy']}%'),
          SizedBox(height: 3.h),
          _buildMetricRow('Hints used'.tr, '${result['hintsUsed']}'),
        ],
      ),
    );
  }

  Widget _buildSoloPlayerResultCard(
    BuildContext context,
    Map<String, dynamic> result,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: MyColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: GradientBoxBorder(
          width: 2.0,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyColors.greenColor.withValues(alpha: 0.8),
              MyColors.greenColor,
            ],
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.darkBlueColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child:
                      (result['avatar'] as String? ?? '').isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: result['avatar'] as String,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  color: MyColors.darkBlueColor,
                                  child: Icon(
                                    Icons.person,
                                    size: 20.sp,
                                    color: MyColors.white.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: MyColors.darkBlueColor,
                                  child: Icon(
                                    Icons.person,
                                    size: 20.sp,
                                    color: MyColors.white.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                          )
                          : Container(
                            color: MyColors.darkBlueColor,
                            child: Icon(
                              Icons.person,
                              size: 20.sp,
                              color: MyColors.white.withValues(alpha: 0.5),
                            ),
                          ),
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
          _buildMetricRow('Total score'.tr, '${result['totalScore']}'),
          SizedBox(height: 3.h),
          _buildMetricRow('Time taken'.tr, result['timeTaken'] as String),
          SizedBox(height: 3.h),
          _buildMetricRow('Accuracy'.tr, '${result['accuracy']}%'),
          SizedBox(height: 3.h),
          _buildMetricRow('Hints used'.tr, '${result['hintsUsed']}'),
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

  bool _isWinningTeam(String teamName) {
    final gameResultController = Get.find<GameResultController>();
    final winnerName = gameResultController.winnerTeamName;
    return winnerName != null && winnerName == teamName;
  }
}
