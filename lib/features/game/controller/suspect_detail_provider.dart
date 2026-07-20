import 'package:get/get.dart';

/// Controller for managing suspect detail screen state
class SuspectDetailController extends GetxController {
  final selectedMainTab = 0.obs;
  final selectedAttachmentType =
      Rxn<String>(); // Videos, Images, Documents, Audio

  /// Set selected main tab
  void setSelectedMainTab(int tab) {
    if (selectedMainTab.value != tab) {
      // Store the old tab value before changing
      int oldTab = selectedMainTab.value;
      selectedMainTab.value = tab;
      
      // Reset attachment type when switching tabs to ensure clean state
      // This prevents audio/video lists from remaining open across tabs
      selectedAttachmentType.value = null;
      
      // Additional cleanup for specific tab transitions
      if (oldTab == 2 && tab != 2) {
        // Coming from investigation tab - ensure all media is stopped
        _stopAllMedia();
      }
      if (oldTab == 1 && tab != 1) {
        // Coming from attachments tab - ensure all media is stopped
        _stopAllMedia();
      }
    }
  }

  /// Set selected attachment type
  void setSelectedAttachmentType(String? type) {
    if (selectedAttachmentType.value != type) {
      // Stop any currently playing media before switching attachment types
      if (selectedAttachmentType.value != null) {
        _stopAllMedia();
      }
      selectedAttachmentType.value = type;
    }
  }

  /// Reset attachment type (go back to grid)
  void resetAttachmentType() {
    if (selectedAttachmentType.value != null) {
      // Stop any playing media before resetting
      _stopAllMedia();
      selectedAttachmentType.value = null;
    }
  }
  
  /// Stop all currently playing media (audio/video)
  void _stopAllMedia() {
    // This will trigger disposal of audio players through widget lifecycle
    // The audio widgets will be disposed when the attachment type changes
    // and new widgets are built
  }
}
