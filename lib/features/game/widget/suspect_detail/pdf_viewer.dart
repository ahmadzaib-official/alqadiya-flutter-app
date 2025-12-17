// PDF Viewer Screen
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  const PDFViewerScreen({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Stack(
        children: [
          // PDF Viewer
          SfPdfViewer.network(
            pdfUrl,
            enableDoubleTapZooming: true,
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              // Handle error
              print('PDF load failed: ${details.error}');
            },
          ),
          // Back button
          Positioned(
            top: 40.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                MyIcons.arrowbackrounded,
                width: 20.w,
                height: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
