import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';

class PrivacyTermsScreen extends StatefulWidget {
  const PrivacyTermsScreen({super.key});

  @override
  State<PrivacyTermsScreen> createState() => _PrivacyTermsScreenState();
}

class _PrivacyTermsScreenState extends State<PrivacyTermsScreen>
    with SingleTickerProviderStateMixin {
  late final WebViewController privacyController;
  late final WebViewController termsController;
  late TabController tabController;

  bool isPrivacyLoading = true;
  bool isTermsLoading = true;
  int currentIndex = 0;

  // URLs for Facebook's privacy policy and terms
  final String privacyPolicyUrl = 'https://www.facebook.com/privacy/policy/';
  final String termsOfServiceUrl = 'https://www.facebook.com/legal/terms';

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    // Initialize Privacy Policy WebView
    privacyController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  isPrivacyLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  isPrivacyLoading = false;
                });
              },
              onWebResourceError: (WebResourceError error) {
                _showErrorSnackbar('Privacy Policy', error.description);
              },
            ),
          )
          ..loadRequest(Uri.parse(privacyPolicyUrl));

    // Initialize Terms of Service WebView
    termsController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  isTermsLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  isTermsLoading = false;
                });
              },
              onWebResourceError: (WebResourceError error) {
                _showErrorSnackbar('Terms of Service', error.description);
              },
            ),
          )
          ..loadRequest(Uri.parse(termsOfServiceUrl));
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      'Error loading $title',
      message,
      backgroundColor: MyColors.redButtonColor,
      colorText: Colors.white,
      duration: Duration(seconds: 5),
      mainButton: TextButton(
        onPressed: () {
          Get.back(); // Close snackbar
          Get.toNamed(
            '/auth/offline-legal',
            arguments: {
              'type':
                  title.toLowerCase().contains('privacy') ? 'privacy' : 'terms',
            },
          );
        },
        child: Text('View Offline'.tr, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Legal Information'.tr,
          style: AppTextStyles.heading3().copyWith(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: MyColors.redButtonColor,
          labelColor: Colors.white,
          // ignore: deprecated_member_use
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          labelStyle: AppTextStyles.labelMedium14(),
          unselectedLabelStyle: AppTextStyles.labelMedium14(),
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          tabs: [
            Tab(
              text: 'Privacy Policy'.tr,
              icon: Icon(Icons.privacy_tip_outlined, size: 20.sp),
            ),
            Tab(
              text: 'Terms of Service'.tr,
              icon: Icon(Icons.description_outlined, size: 20.sp),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white, size: 24.sp),
            onPressed: () {
              if (currentIndex == 0) {
                privacyController.reload();
              } else {
                termsController.reload();
              }
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // Privacy Policy Tab
          _buildWebViewTab(
            controller: privacyController,
            isLoading: isPrivacyLoading,
            title: 'Privacy Policy',
          ),
          // Terms of Service Tab
          _buildWebViewTab(
            controller: termsController,
            isLoading: isTermsLoading,
            title: 'Terms of Service',
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewTab({
    required WebViewController controller,
    required bool isLoading,
    required String title,
  }) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (isLoading)
          Container(
            color: MyColors.backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      MyColors.redButtonColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading $title...'.tr,
                    style: AppTextStyles.bodyTextRegular16().copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Please wait while we load the content'.tr,
                    style: AppTextStyles.captionRegular12().copyWith(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
