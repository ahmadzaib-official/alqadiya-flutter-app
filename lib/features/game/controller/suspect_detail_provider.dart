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
      // Reset attachment type when switching AWAY from investigation tab
      // to ensure clean state when entering other tabs
      if (oldTab == 2) { // if we were in investigation tab
        selectedAttachmentType.value = null;
      }
      // Also reset when switching to attachments tab to show grid view
      if (tab == 1) { // if we're switching to attachments tab
        selectedAttachmentType.value = null;
      }
    }
  }

  /// Set selected attachment type
  void setSelectedAttachmentType(String? type) {
    if (selectedAttachmentType.value != type) {
      selectedAttachmentType.value = type;
    }
  }

  /// Reset attachment type (go back to grid)
  void resetAttachmentType() {
    if (selectedAttachmentType.value != null) {
      selectedAttachmentType.value = null;
    }
  }
}
