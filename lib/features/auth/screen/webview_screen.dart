import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:shimmer/shimmer.dart';

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

  Widget _buildShimmerLoading() {
    return Container(
      color: MyColors.backgroundColor,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[850]!,
        highlightColor: Colors.grey[700]!,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title shimmer
              Container(
                width: double.infinity,
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 20.h),

              // Paragraph shimmer lines
              ...List.generate(16, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    width:
                        index % 3 == 0
                            ? double.infinity * 0.7
                            : double.infinity,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                );
              }),

              SizedBox(height: 24.h),

              // Section title shimmer
              Container(
                width: double.infinity * 0.5,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 16.h),

              // More paragraph lines
              ...List.generate(6, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    width:
                        index % 4 == 0
                            ? double.infinity * 0.8
                            : double.infinity,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
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
          if (isLoading) _buildShimmerLoading(),
        ],
      ),
    );
  }
}
