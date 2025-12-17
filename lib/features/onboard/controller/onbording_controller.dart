import 'dart:async';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/features/location/find_location_user_controller.dart';
import 'package:alqadiya_game/features/onboard/model/onbording_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  late PageController pageController;
  var isContentVisible = false.obs;

  void showContent() {
    isContentVisible.value = true;
  }

  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      image1: MyImages.onboard1,
      title: 'onboardingHeader1'.tr,
      description: 'onboardingDescription1'.tr,
    ),
    OnboardingModel(
      image1: MyImages.onboard2,
      title: 'onboardingHeader2'.tr,
      description:
          'Find the perfect stay for every occasion — from family getaways to special celebrations.'
              .tr,
    ),
    OnboardingModel(
      image1: MyImages.onboard3,
      title: 'onboardingHeader3'.tr,
      description:
          'Collect points with every booking and redeem them for discounts, gifts, or free nights.'
              .tr,
    ),
    OnboardingModel(
      image1: MyImages.onboard3,
      title: 'onboardingHeader3'.tr,
      description:
          'Collect points with every booking and redeem them for discounts, gifts, or free nights.'
              .tr,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0, viewportFraction: 1.0);
    // startAutoSlide();
    LocationServices().getCurrentLocation();
  }

  @override
  void onClose() {
    pageController.dispose();
    // stopAutoSlide();
    super.onClose();
  }

  Timer? _timer;
  void startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!pageController.hasClients) return;

      final nextPage =
          currentIndex.value < onboardingPages.length - 1
              ? currentIndex.value + 1
              : 0;

      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutQuart,
      );
    });
  }

  void stopAutoSlide() {
    _timer?.cancel();
    _timer = null;
  }

  void updateIndex(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
    stopAutoSlide();
    startAutoSlide();
  }
}
