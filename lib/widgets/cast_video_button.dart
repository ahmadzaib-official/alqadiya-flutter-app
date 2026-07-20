import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/services/screen_cast_service.dart';

/// Button to cast video to connected device
/// Shows when a cast device is connected
class CastVideoButton extends StatelessWidget {
  final String videoUrl;
  final String? title;
  final VoidCallback? onCastStarted;

  const CastVideoButton({
    super.key,
    required this.videoUrl,
    this.title,
    this.onCastStarted,
  });

  @override
  Widget build(BuildContext context) {
    final castService = Get.find<ScreenCastService>();

    return Obx(() {
      // Only show if connected to a cast device
      if (!castService.isConnected.value) {
        return const SizedBox.shrink();
      }

      return IconButton(
        icon: const Icon(Icons.cast_connected),
        color: Colors.white,
        tooltip:
            'Cast to ${castService.connectedDevice.value?.name ?? "device"}',
        onPressed: () async {
          // Load media to cast device
          final success = await castService.loadMedia(
            mediaUrl: videoUrl,
            title: title ?? 'Video',
            contentType: 'video/mp4',
          );

          if (success) {
            onCastStarted?.call();

            Get.snackbar(
              'Casting'.tr,
              'Video is now playing on ${castService.connectedDevice.value?.name}',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        },
      );
    });
  }
}
