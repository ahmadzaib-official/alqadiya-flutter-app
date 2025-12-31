import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/transactions/controller/transaction_receipt_controller.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionReceiptScreen extends StatelessWidget {
  const TransactionReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionReceiptController>();
    return Scaffold( 
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        imageUrl: "https://picsum.photos/200",
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              child: Column(
                children: [
                  // Header
                  HomeHeader(
                    onChromTap: () {},
                    title: Text(
                      'Transaction Receipt'.tr,
                      style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                    ),
                    actionButtons: GestureDetector(
                      onTap: () => Get.back(),
                      child: SvgPicture.asset(MyIcons.arrowbackrounded),
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.sp),
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: MyColors.redButtonColor,
                            ),
                          );
                        }

                        final receipt = controller.receipt.value;
                        if (receipt == null) {
                          return Center(
                            child: Text(
                              "Receipt not found".tr,
                              style: AppTextStyles.heading2().copyWith(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20.h),
                              // Success Icon/Status
                              Icon(
                                Icons.check_circle_outline,
                                color: MyColors.greenColor,
                                size: 50.sp,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                receipt.status ?? "Success".tr,
                                style: AppTextStyles.heading1().copyWith(
                                  fontSize: 14.sp,
                                  color: MyColors.greenColor,
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // Receipt Details Card
                              Container(
                                padding: EdgeInsets.all(15.sp),
                                decoration: BoxDecoration(
                                  color: MyColors.black.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: MyColors.white.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildReceiptRow(
                                      "Transaction ID".tr,
                                      receipt.id != null
                                          ? receipt.id!.substring(0, 6) +
                                              "..." +
                                              receipt.id!.substring(
                                                receipt.id!.length - 6,
                                              )
                                          : "N/A".tr,
                                    ),
                                    _buildDivider(),
                                    _buildReceiptRow(
                                      "Date".tr,
                                      receipt.createdAt != null
                                          ? DateFormat(
                                            'yyyy-MM-dd HH:mm',
                                          ).format(receipt.createdAt!)
                                          : "N/A".tr,
                                    ),
                                    _buildDivider(),
                                    _buildReceiptRow(
                                      "Description".tr,
                                      receipt.description ?? "N/A".tr,
                                    ),
                                    _buildDivider(),
                                    _buildReceiptRow(
                                      "Type".tr,
                                      receipt.type ?? "N/A".tr,
                                    ),
                                    _buildDivider(),
                                    _buildReceiptRow(
                                      "Points".tr,
                                      "${receipt.points ?? 0}",
                                    ),
                                    _buildDivider(),
                                    _buildReceiptRow(
                                      "Amount".tr,
                                      "${receipt.price ?? 0} ${receipt.currency ?? 'KD'}",
                                      valueColor: MyColors.redButtonColor,
                                      isBold: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyTextMedium16().copyWith(
              fontSize: 10.sp,
              color: MyColors.white.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style:
                isBold
                    ? AppTextStyles.heading1().copyWith(
                      fontSize: 10.sp,
                      color: valueColor ?? MyColors.white,
                    )
                    : AppTextStyles.heading2().copyWith(
                      fontSize: 10.sp,
                      color: valueColor ?? MyColors.white,
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: MyColors.white.withValues(alpha: 0.1), height: 1.h);
  }
}
