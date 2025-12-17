import 'package:alqadiya_game/features/notifcation/model/notifcation_modal.dart';
import 'package:alqadiya_game/core/network/api_fetch.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var selectedCategory = 'All'.obs;
  var notifications = <NotificationMessage>[].obs;
  var isLoading = false.obs;
  var hasMore = true.obs;
  var currentPage = 1;
  var isRefreshing = false.obs;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(language: Get.locale?.languageCode);
  }

  Future<void> fetchNotifications({
    bool refresh = false,
    String? language,
  }) async {
    if (isLoading.value && !refresh) return;
    // try {
    //   isLoading(true);
    //   isRefreshing.value = refresh;

    //   if (refresh) {
    //     currentPage = 1;
    //     hasMore(true);
    //   }

    //   final response = await ApiFetch().getNotifications(
    //     page: currentPage,
    //     limit: limit,
    //     language: language ?? Get.locale?.languageCode ?? 'en',
    //   );

    //   if (refresh) {
    //     notifications.assignAll(response.data ?? []);
    //   } else {
    //     notifications.addAll(response.data ?? []);
    //   }

    //   if ((response.data?.length ?? 0) < limit) {
    //     hasMore(false);
    //   } else {
    //     currentPage++;
    //   }
    // } catch (e) {
    //   // Get.snackbar('Error', 'Failed to load notifications');
    // } finally {
    //   isLoading(false);
    //   isRefreshing.value = false;
    // }
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications(refresh: true);
  }

  Future<void> loadMoreNotifications() async {
    if (!isLoading.value && hasMore.value) {
      await fetchNotifications();
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    refreshNotifications();
  }

  int get unreadCount {
    return notifications.where((n) => n.state == 'not_opened').length;
  }

  List<NotificationMessage> get filteredNotifications {
    if (selectedCategory.value == 'All') return notifications;
    return notifications
        .where(
          (n) =>
              n.notificationType!.toLowerCase() ==
              selectedCategory.value.toLowerCase(),
        )
        .toList();
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(state: 'opened');
        notifications.refresh();
      }
      // await ApiFetch().notifcationStateChange({
      //   "ids": [notificationId],
      //   "state": "opened",
      // });
    } catch (e) {
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(
          state: 'not_opened',
        );
        notifications.refresh();
      }
      Get.snackbar('Error', 'Failed to mark notification as read');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final unreadIds =
          notifications
              .where((n) => n.state == 'not_opened')
              .map((n) => n.id ?? '')
              .where((id) => id.isNotEmpty)
              .toList();

      if (unreadIds.isEmpty) return;

      for (var i = 0; i < notifications.length; i++) {
        if (notifications[i].state == 'not_opened') {
          notifications[i] = notifications[i].copyWith(state: 'opened');
        }
      }
      notifications.refresh();

      // await ApiFetch().notifcationStateChange({
      //   "ids": unreadIds,
      //   "state": "opened",
      // });
    } catch (e) {
      for (var i = 0; i < notifications.length; i++) {
        if (notifications[i].state == 'opened') {
          notifications[i] = notifications[i].copyWith(state: 'not_opened');
        }
      }
      notifications.refresh();
      Get.snackbar('Error', 'Failed to mark all notifications as read');
    }
  }
}
