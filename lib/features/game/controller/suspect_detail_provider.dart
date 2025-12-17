import 'package:get/get.dart';

/// Controller for managing suspect detail screen state
class SuspectDetailController extends GetxController {
  final selectedMainTab = 0.obs;
  final selectedAttachmentType = Rxn<String>(); // Videos, Images, Documents, Audio

  /// Set selected main tab
  void setSelectedMainTab(int tab) {
    if (selectedMainTab.value != tab) {
      selectedMainTab.value = tab;
      // Reset attachment type when switching tabs
      if (tab != 1) {
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
