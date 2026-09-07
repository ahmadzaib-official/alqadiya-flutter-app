import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:get/get.dart';

class PdfViewerStateController extends GetxController {
  final String pdfUrl;

  final PdfViewerController pdfViewerController = PdfViewerController();
  final RxBool isHighlightMode = false.obs;
  final RxBool isLoading = true.obs;
  final RxnString localPdfPath = RxnString();

  PdfViewerStateController({required this.pdfUrl});

  @override
  void onInit() {
    super.onInit();
    _checkLocalPdf();
  }

  Future<void> _checkLocalPdf() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      // Generate a unique filename based on the URL
      final hashBytes = utf8.encode(pdfUrl);
      final hashStr = md5.convert(hashBytes).toString();
      final filePath = '${dir.path}/$hashStr.pdf';

      final file = File(filePath);
      if (await file.exists()) {
        localPdfPath.value = filePath;
      }
    } catch (e) {
      print("Error checking local PDF: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveHighlightsAndPop(BuildContext context) async {
    try {
      final bytes = await pdfViewerController.saveDocument();

      final dir = await getApplicationDocumentsDirectory();
      final hashBytes = utf8.encode(pdfUrl);
      final hashStr = md5.convert(hashBytes).toString();
      final filePath = '${dir.path}/$hashStr.pdf';

      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
    } catch (e) {
      print("Error saving PDF highlights: $e");
    }

    if (context.mounted) {
      Navigator.pop(context);
    }

    // Clean up controller after popping
    Get.delete<PdfViewerStateController>(tag: pdfUrl);
  }

  void toggleHighlightMode() {
    isHighlightMode.value = !isHighlightMode.value;
    pdfViewerController.annotationMode =
        isHighlightMode.value
            ? PdfAnnotationMode.highlight
            : PdfAnnotationMode.none;
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  const PDFViewerScreen({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PdfViewerStateController(pdfUrl: pdfUrl),
      tag: pdfUrl,
    );

    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: MyColors.backgroundColor,
          body: Center(
            child: CircularProgressIndicator(color: MyColors.redButtonColor),
          ),
        );
      }

      return WillPopScope(
        onWillPop: () async {
          await controller.saveHighlightsAndPop(context);
          return false;
        },
        child: Scaffold(
          backgroundColor: MyColors.backgroundColor,
          body: Stack(
            children: [
              // PDF Viewer
              controller.localPdfPath.value != null
                  ? SfPdfViewer.file(
                    File(controller.localPdfPath.value!),
                    controller: controller.pdfViewerController,
                    enableDoubleTapZooming: true,
                    onDocumentLoadFailed: (
                      PdfDocumentLoadFailedDetails details,
                    ) {
                      print('Local PDF load failed: ${details.error}');
                    },
                  )
                  : SfPdfViewer.network(
                    pdfUrl,
                    controller: controller.pdfViewerController,
                    enableDoubleTapZooming: true,
                    onDocumentLoadFailed: (
                      PdfDocumentLoadFailedDetails details,
                    ) {
                      print('Network PDF load failed: ${details.error}');
                    },
                  ),

              // Top buttons area
              Positioned(
                top: 40.h,
                left: 20.w,
                child: Row(
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => controller.saveHighlightsAndPop(context),
                      child: Container(
                        padding: EdgeInsets.all(5.sp),
                        decoration: BoxDecoration(
                          color: MyColors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          MyIcons.arrowbackrounded,
                          width: 16.w,
                          height: 16.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),

                    // Highlighter button
                    GestureDetector(
                      onTap: controller.toggleHighlightMode,
                      child: Container(
                        // padding: EdgeInsets.all(3.sp),
                        decoration: BoxDecoration(
                          color:
                              controller.isHighlightMode.value
                                  ? MyColors.redButtonColor
                                  : MyColors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(6.sp),
                          child: Icon(
                            Iconsax.edit, // standard flutter icon for pen/edit
                            color: Colors.white,
                            size: 13.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
