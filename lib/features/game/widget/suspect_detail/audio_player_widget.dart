// Audio Player Widget
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/controller/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String title;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.title,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayerController _audioController;
  final String _controllerTag =
      'audio_player_${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    // Create controller with unique tag for this widget instance
    _audioController = Get.put(AudioPlayerController(), tag: _controllerTag);
    // Initialize audio after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _audioController.initializeAudio(widget.audioUrl);
    });
  }

  @override
  void dispose() {
    // Remove controller when widget is disposed
    if (Get.isRegistered<AudioPlayerController>(tag: _controllerTag)) {
      Get.delete<AudioPlayerController>(tag: _controllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Play/Pause button
            GestureDetector(
              onTap: () => _audioController.togglePlayPause(),
              child: SvgPicture.asset(
                _audioController.isPlaying.value ? MyIcons.pause : MyIcons.play,
              ),
            ),

            // Progress indicator
            ClipRRect(
              borderRadius: BorderRadius.circular(2.r),
              child: LinearProgressIndicator(
                value: _audioController.progress,
                backgroundColor: MyColors.black.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(MyColors.BlueColor),
                minHeight: 3.h,
              ),
            ),

            // Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.heading2().copyWith(
                    fontSize: 8.sp,
                    color: MyColors.BlueColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
