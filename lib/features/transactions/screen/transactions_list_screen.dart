import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/transactions/controller/transactions_provider.dart';
import 'package:alqadiya_game/features/transactions/model/transaction_model.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/localization_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:get/get.dart';

class TransactionsListScreen extends StatelessWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize transactions controller
    final transactionsController = Get.find<TransactionsController>();

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
                      'Transactions'.tr,
                      style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                    ),
                    actionButtons: GestureDetector(
                      onTap: () => Get.back(),
                      child: SvgPicture.asset(MyIcons.arrowbackrounded),
                    ),
                  ),

                  // Main Content - Transactions List
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.sp),
                      child: Obx(() {
                        if (transactionsController.isLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: MyColors.redButtonColor,
                            ),
                          );
                        }

                        if (transactionsController.transactions.isEmpty) {
                          return Center(
                            child: Text(
                              "No transactions".tr,
                              style: AppTextStyles.heading2().copyWith(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: transactionsController.transactions.length,
                          separatorBuilder:
                              (context, index) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final transaction =
                                transactionsController.transactions[index];
                            return _buildTransactionCard(context, transaction);
                          },
                        );
                      }),
                    ),
                  ),

                  LocalizationFooter(showDividerInColumn: true).buildDivider(),
                  LocalizationFooter(usePositioned: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    TransactionModel transaction,
  ) {
    return Container(
      padding: EdgeInsets.all(6.sp),
      // margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: MyColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          // Left side - Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and time
                Text(
                  '${transaction.createdAt?.day}, ${transaction.createdAt?.hour}',
                  // '${transaction.createdAt?.day}, ${transaction.createdAt?.hour}',
                  style: AppTextStyles.heading2().copyWith(
                    fontSize: 6.sp,
                    color: MyColors.redButtonColor,
                  ),
                ),
                SizedBox(height: 8.h),
                // Price
                Row(
                  children: [
                    Text(
                      'Price '.tr,
                      style: AppTextStyles.heading2().copyWith(
                        fontSize: 7.sp,
                        color: MyColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(width: 2.w),

                    SizedBox(
                      height: 20.h,
                      child: VerticalDivider(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    SizedBox(width: 2.w),

                    Text(
                      transaction.price.toString(),
                      style: AppTextStyles.heading1().copyWith(
                        fontSize: 7.sp,
                        color: MyColors.white,
                      ),
                    ),
                    Text(
                      ' KD',
                      style: AppTextStyles.heading2().copyWith(
                        fontSize: 6.sp,
                        color: MyColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Spacer(),
          // Plan and Points
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Plan'.tr,
                style: AppTextStyles.heading2().copyWith(
                  fontSize: 7.sp,
                  color: MyColors.white.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(width: 2.w),

              SizedBox(
                height: 20.h,
                child: VerticalDivider(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                transaction.points.toString(),
                style: AppTextStyles.heading1().copyWith(
                  fontSize: 7.sp,
                  color: MyColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),

          // Right side - Plan/Points and View receipt button
          GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.transactionReceiptScreen,
                arguments: transaction.id,
              );
            },
            child: Container(
              width: 60.w,
              padding: EdgeInsets.symmetric(vertical: 4.sp),
              decoration: BoxDecoration(
                color: MyColors.greenColor,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Spacer(flex: 6),

                  Text(
                    'View receipt'.tr,
                    style: AppTextStyles.heading2().copyWith(
                      fontSize: 6.sp,
                      color: MyColors.white,
                    ),
                  ),
                  Spacer(flex: 1),
                  SvgPicture.asset(MyIcons.arrow_right),
                  Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
