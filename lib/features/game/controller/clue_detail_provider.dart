import 'package:get/get.dart';

/// Controller for managing clue detail screen state
class ClueDetailController extends GetxController {
  // 0 = Clue Information, 1 = Attachments
  final selectedTab = 0.obs;
  final selectedAttachmentType = Rxn<String>(); // Videos, Images, Audio, Documents

  /// Set selected tab
  void setSelectedTab(int tab) {
    if (selectedTab.value != tab) {
      selectedTab.value = tab;
      // Reset attachment type when switching tabs
      if (tab == 0) {
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
