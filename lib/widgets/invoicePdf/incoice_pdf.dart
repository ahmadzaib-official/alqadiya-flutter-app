// import 'package:alqadiya_game/invoicePdf/invoice_pdf_modal.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:open_file/open_file.dart';
// import 'dart:io';
// // ignore: depend_on_referenced_packages
// import 'package:path_provider/path_provider.dart';
// import 'dart:typed_data'; // for Uint8List
// import 'package:flutter/services.dart' show rootBundle;
// // ignore: depend_on_referenced_packages
// import 'package:intl/intl.dart';
// class InvoicePdf {
//   static Future<void> generateAndViewInvoice(InvoiceModel invoiceModel) async {
//     // Load images from assets
//     final logoBytes = await _getLogoBytes();
//     final dateTime = await _getImageBytes('date');
//     final logoBlue = await _getImageBytes('logo_blue');
//     final group = await _getImageBytes('group');
//     final knetCard = await _getImageBytes('KNETcard');
//     final lucation = await _getImageBytes('lucation');
//     final propertyImageBytes = await _getImageBytes('bg');
//     final qrCodeBytes = await _getQRCodeBytes();
//     double fontsize = 14;
//     // Create a PDF document
//     final pdf = pw.Document();

//     // Define colors
//     final primaryColor = PdfColor.fromHex('#29397E');
//     final secondaryColor = PdfColor.fromHex('#E9EEF4');

//     final backgroundColor = PdfColor.fromHex('#F9FAFB');

//     String issueDate = DateFormat("d MMMM , yyyy").format(DateTime.now());
//     String paymentDate = DateFormat("d MMMM , yyyy").format(invoiceModel.paymentDue);
// String formatDateRange() {
//   DateTime start = invoiceModel.startDate!;
//   DateTime end = invoiceModel.endDate!;

//   String startStr = DateFormat("d MMMM yyyy").format(start);
//   String endStr = DateFormat("d MMMM yyyy").format(end);

//   return "From $startStr To $endStr";
// }
//     // Add a page
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: pw.EdgeInsets.all(15),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // Header Section
//               pw.Container(
//                 decoration: pw.BoxDecoration(
//                   color: primaryColor,
//                   borderRadius: pw.BorderRadius.circular(16),
//                 ),
//                 padding: pw.EdgeInsets.all(22),
//                 child: pw.Column(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Company Logo
//                     pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Image(pw.MemoryImage(logoBytes), width: 150),
//                             pw.Column(
//                               children: [
//                                 pw.Text(
//                                   'Invoice No.',
//                                   style: pw.TextStyle(
//                                     fontSize: fontsize,
//                                     color: PdfColors.white,
//                                   ),
//                                 ),
//                                 pw.Text(
//                                   '#000225',
//                                   style: pw.TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: pw.FontWeight.bold,
//                                     color: PdfColors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         pw.SizedBox(height: 10),
//                         pw.Text(
//                           'Billed To:',
//                           style: pw.TextStyle(
//                             fontSize: fontsize,
//                             color: PdfColors.white,
//                           ),
//                         ),
//                         pw.SizedBox(height: 10),
//                         pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Column(
//                               crossAxisAlignment: pw.CrossAxisAlignment.start,
//                               children: [
//                                 pw.Text(
//                                   invoiceModel.customer.name,
//                                   style: pw.TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: pw.FontWeight.bold,
//                                     color: PdfColors.white,
//                                   ),
//                                 ),
//                                 pw.SizedBox(height: 10),
//                                 pw.Text(
//                                   invoiceModel.customer.address,
//                                   style: pw.TextStyle(
//                                     fontSize: fontsize,
//                                     color: PdfColors.white,
//                                   ),
//                                 ),
//                                 pw.SizedBox(height: 5),
//                                 pw.Text(
//                                   'Office No. 318.',
//                                   style: pw.TextStyle(
//                                     fontSize: fontsize,
//                                     color: PdfColors.white,
//                                   ),
//                                 ),
//                                 pw.SizedBox(height: 5),
//                                 pw.Text(
//                                   invoiceModel.customer.phone,
//                                   style: pw.TextStyle(
//                                     fontSize: fontsize,
//                                     color: PdfColors.white,
//                                   ),
//                                 ),
//                                 pw.SizedBox(height: 5),
//                                 pw.Text(
//                                   invoiceModel.customer.email,
//                                   style: pw.TextStyle(
//                                     fontSize: fontsize,
//                                     color: PdfColors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             pw.Column(
//                               crossAxisAlignment: pw.CrossAxisAlignment.start,
//                               children: [
//                                 pw.Text(
//                                   'Issued on',
//                                   style: pw.TextStyle(
//                                     fontSize: fontsize,
//                                     color: PdfColors.white,
//                                   ),
//                                 ),
//                                 pw.Text(
//                                   issueDate,
//                                   style: pw.TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: pw.FontWeight.bold,
//                                     color: PdfColors.white,
//                                   ),
//                                 ),
//                                 pw.SizedBox(height: 10),
//                                 pw.Text(
//                                   'Payment Due',
//                                   style: pw.TextStyle(
//                                     fontSize: fontsize,
//                                     color: PdfColors.white,
//                                   ),
//                                 ),
//                                 pw.Text(
//                                   paymentDate,
//                                   style: pw.TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: pw.FontWeight.bold,
//                                     color: PdfColors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               pw.SizedBox(height: 25),

//               // Booking Details Section
//               pw.Container(
//                 decoration: pw.BoxDecoration(
//                   color: backgroundColor,
//                   borderRadius: pw.BorderRadius.circular(8),
//                 ),
//                 padding: pw.EdgeInsets.all(16),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     // Image and Title
//                     pw.Row(
//                       children: [
//                         pw.Container(
//                           width: 70,
//                           height: 50,
//                           decoration: pw.BoxDecoration(
//                             borderRadius: pw.BorderRadius.circular(10),
//                             image: pw.DecorationImage(
//                               image: pw.MemoryImage(propertyImageBytes),
//                               fit: pw.BoxFit.cover,
//                             ),
//                           ),
//                         ),

//                         pw.SizedBox(width: 10),
//                         pw.Text(
//                           invoiceModel.chaletTitle,
//                           style: pw.TextStyle(
//                             fontSize: 16,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),

//                     pw.SizedBox(height: 16),

//                     // Dates and Guests
//                     pw.Row(
//                       children: [
//                         pw.Image(pw.MemoryImage(dateTime), width: 20),

//                         pw.SizedBox(width: 5),
//                         pw.Text(
//                           formatDateRange(),
//                           style: pw.TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                     pw.SizedBox(height: 6),

//                     pw.Row(
//                       children: [
//                         pw.Image(pw.MemoryImage(group), width: 20),
//                         pw.SizedBox(width: 5),
//                         pw.Text('${invoiceModel.noOfGuests} Guests', style: pw.TextStyle(fontSize: 12)),
//                       ],
//                     ),
//                     pw.SizedBox(height: 6),

//                     pw.Row(
//                       children: [
//                         pw.Image(pw.MemoryImage(lucation), width: 20),

//                         pw.SizedBox(width: 5),
//                         pw.Text(
//                           invoiceModel.chaletAddress,
//                           style: pw.TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),

//                     pw.SizedBox(height: 10),

//                     // Price Breakdown
//                     pw.Column(
//                       children:
//                           invoiceModel.customization.map((item) {
//                             return pw.Padding(
//                               padding: pw.EdgeInsets.symmetric(vertical: 5),
//                               child: pw.Row(
//                                 mainAxisAlignment:
//                                     pw.MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   pw.Text(
//                                     item.title,
//                                     style: pw.TextStyle(fontSize: fontsize),
//                                   ),
//                                   pw.Text(
//                                     item.price.toString(),
//                                     style: pw.TextStyle(fontSize: fontsize),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                     ),
//                   ],
//                 ),
//               ),

//               pw.SizedBox(height: 20),

//               // Total Section
//               pw.Align(
//                 alignment: pw.Alignment.centerRight,
//                 child: pw.Container(
//                   decoration: pw.BoxDecoration(
//                     color: backgroundColor,
//                     borderRadius: pw.BorderRadius.circular(8),
//                   ),
//                   padding: pw.EdgeInsets.symmetric(
//                     vertical: 10,
//                     horizontal: 20,
//                   ),
//                   child: pw.Row(
//                     mainAxisSize: pw.MainAxisSize.min,
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Row(
//                         children: [
//                           pw.Text(
//                             'Total (KWD) Paid Via',
//                             style: pw.TextStyle(fontSize: 14),
//                           ),
//                           pw.SizedBox(width: 5),
//                           pw.Image(pw.MemoryImage(knetCard), width: 20),
//                         ],
//                       ),
//                       pw.SizedBox(width: 10),
//                       pw.Text(
//                         invoiceModel.totalAmount.toString(),
//                         style: pw.TextStyle(
//                           fontSize: 23,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Footer Section
//               // Footer Section
//               pw.Divider(thickness: 1, color: secondaryColor),
//               pw.SizedBox(height: 20),

//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   // === Column 1: Company Info + QR Code ===
//                   pw.Expanded(
//                     flex: 2, // Give more width to this column
//                     child: pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Image(pw.MemoryImage(logoBlue), width: 120),
//                         pw.SizedBox(height: 8),
//                         pw.Text(
//                           'Kuwait, Souq Al-Manakh, Ground Floor, Office No. 318.',
//                           style: pw.TextStyle(
//                             fontSize: 11,
//                             color: PdfColors.grey,
//                           ),
//                         ),
//                         pw.Text(
//                           'support@bazar.com',
//                           style: pw.TextStyle(
//                             fontSize: 11,
//                             color: primaryColor,
//                             decoration: pw.TextDecoration.underline,
//                           ),
//                         ),
//                         pw.SizedBox(height: 12),
//                         pw.Row(
//                           children: [
//                             pw.Image(pw.MemoryImage(qrCodeBytes), width: 30),
//                             pw.SizedBox(width: 5),
//                             pw.UrlLink(
//                               destination: 'https://yourbookinglink.com',
//                               child: pw.Text(
//                                 'Or View Booking Online',
//                                 style: pw.TextStyle(
//                                   fontSize: 11,
//                                   color: primaryColor,
//                                   decoration: pw.TextDecoration.underline,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   // === Column 2: Check-in / Cancellation ===
//                   pw.Expanded(
//                     flex: 2, // Adjust flex value for better distribution
//                     child: pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         // Check-in / Check-out
//                         pw.Text(
//                           'Check-in / Check-out times',
//                           style: pw.TextStyle(
//                             fontSize: 12,

//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                         pw.SizedBox(height: 4),
//                         pw.Row(
//                           children: [
//                             pw.Image(pw.MemoryImage(dateTime), width: 10),

//                             pw.SizedBox(width: 5),
//                             pw.Text(
//                               'Check-in: 02:00 PM',

//                               style: pw.TextStyle(
//                                 fontSize: 11,
//                                 color: PdfColors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                         pw.Row(
//                           children: [
//                             pw.Image(pw.MemoryImage(dateTime), width: 10),

//                             pw.SizedBox(width: 5),
//                             pw.Text(
//                               'Checkout: 12:00 PM',
//                               style: pw.TextStyle(
//                                 fontSize: 11,
//                                 color: PdfColors.grey,
//                               ),
//                             ),
//                           ],
//                         ),

//                         pw.SizedBox(height: 12),

//                         // Cancellation Policy
//                         pw.Text(
//                           'Cancellation Policy',
//                           style: pw.TextStyle(
//                             fontSize: 12,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                         pw.Text(
//                           'Cancel up to 72 hours before check-in for refund.',
//                           style: pw.TextStyle(
//                             fontSize: 11,
//                             color: PdfColors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // === Column 3: Refund & Deposit Info ===
//                   pw.Expanded(
//                     flex: 3, // Adjust flex value for better distribution
//                     child: pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         // Refund Instructions
//                         pw.Text(
//                           'Refund Instructions',
//                           style: pw.TextStyle(
//                             fontSize: 12,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                         pw.Text(
//                           'Refundable Security Deposit: 200 KWD',
//                           style: pw.TextStyle(
//                             fontSize: 11,
//                             color: PdfColors.grey,
//                           ),
//                         ),
//                         pw.Text(
//                           'Refund Method: Same payment method',
//                           style: pw.TextStyle(
//                             fontSize: 11,
//                             color: PdfColors.grey,
//                           ),
//                         ),
//                         pw.Text(
//                           'Refund Period: 72 hours after checkout',
//                           style: pw.TextStyle(
//                             fontSize: 11,
//                             color: PdfColors.grey,
//                           ),
//                         ),

//                         pw.SizedBox(height: 12),

//                         // Deposit Info
//                         pw.Text(
//                           'Deposit Info',
//                           style: pw.TextStyle(
//                             fontSize: 12,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                         pw.Paragraph(
//                           text:
//                               'A refundable security deposit of 200 KWD is required and will be returned within 72 hours after checkout, if no damages are reported.',
//                           style: pw.TextStyle(
//                             fontSize: 11,
//                             color: PdfColors.grey,
//                           ),
//                           textAlign: pw.TextAlign.left,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     // Save the PDF file
//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/invoice_000225.pdf");
//     await file.writeAsBytes(await pdf.save());

//     // Open the PDF file
//     await OpenFile.open(file.path);
//   }

//   // Helper function to load logo bytes from assets
//   static Future<Uint8List> _getLogoBytes() async {
//     final data = await rootBundle.load('assets/images/logo.png');
//     return data.buffer.asUint8List();
//   }

//   // Helper function to load property image
//   static Future<Uint8List> _getImageBytes(String imagePath) async {
//     final data = await rootBundle.load('assets/images/$imagePath.png');
//     return data.buffer.asUint8List();
//   }

//   // Helper function to load QR code
//   static Future<Uint8List> _getQRCodeBytes() async {
//     final data = await rootBundle.load('assets/images/qr.png');
//     return data.buffer.asUint8List();
//   }
// }
