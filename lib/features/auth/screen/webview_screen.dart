import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;
  String? title;
  String? url;

  @override
  void initState() {
    super.initState();

    // Get arguments passed from navigation
    final arguments = Get.arguments as Map<String, dynamic>?;
    title = arguments?['title'] ?? 'Loading...';
    url = arguments?['url'] ?? 'https://www.facebook.com/privacy/policy/';

    // Initialize WebView controller
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading progress if needed
              },
              onPageStarted: (String url) {
                setState(() {
                  isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  isLoading = false;
                });
              },
              onWebResourceError: (WebResourceError error) {
                Get.snackbar(
                  'Error',
                  'Failed to load page: ${error.description}',
                  backgroundColor: MyColors.redButtonColor,
                  colorText: Colors.white,
                );
              },
            ),
          )
          ..loadRequest(Uri.parse(url!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          title ?? 'Loading...',
          style: AppTextStyles.heading3().copyWith(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
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
                      'Loading...'.tr,
                      style: AppTextStyles.bodyTextRegular16().copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
