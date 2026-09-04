import 'package:alqadiya_game/core/constants/my_icons.dart';
// import 'package:alqadiya_game/core/routes/app_routes.dart';
// import 'package:alqadiya_game/core/services/auth_guard.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/auth/controller/user_controller.dart';
import 'package:alqadiya_game/features/payment/controller/payment_controller.dart';

import 'package:alqadiya_game/core/widgets/custom_button.dart';
import 'package:alqadiya_game/core/widgets/custom_textfield.dart';
import 'package:alqadiya_game/core/widgets/gradient_box_border.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _discountController = TextEditingController();
  late final UserController userController;
  VoidCallback? onProfileTap;

  @override
  void initState() {
    super.initState();
    userController = Get.find<UserController>();
    // The paymentController.fetchPaymentMethods() will auto-select the first method once loaded.
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void goBack() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Future.delayed(Duration(milliseconds: 60), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize payment controller
    final paymentController = Get.find<PaymentController>();
    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        if (didPop) {
          // Force landscape
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        }
      },
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        bottomNavigationBar: _buildPaymentBar(context),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile avatar
                    GestureDetector(
                      onTap: () {
                        // AuthGuard.executeIfAuthenticated(
                        //   title: 'Profile Access'.tr,
                        //   message: 'Please sign in to view your profile'.tr,
                        //   action: () => Get.toNamed(AppRoutes.settingsScreen),
                        // );
                      },
                      child: Obx(() {
                        return CircleAvatar(
                          backgroundColor: MyColors.darkBlueColor,
                          backgroundImage:
                              userController.user.value?.photoUrl != null
                                  ? CachedNetworkImageProvider(
                                    userController.user.value!.photoUrl!,
                                  )
                                  : const AssetImage(MyIcons.userImage)
                                      as ImageProvider,
                          radius: 17.sp,
                        );
                      }),
                    ),
                    // Back icon
                    GestureDetector(
                      onTap: () {
                        goBack();
                      },
                      child: SvgPicture.asset(MyIcons.arrowbackrounded),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Header
                Text(
                  'Payment'.tr,
                  style: AppTextStyles.heading1().copyWith(fontSize: 24.sp),
                ),

                SizedBox(height: 10.h),
                Divider(
                  color: MyColors.white.withValues(alpha: 0.1),
                  thickness: 1.h,
                ),
                SizedBox(height: 10.h),
                // Order Detail Section
                _buildOrderDetailSection(paymentController),
                SizedBox(height: 10.h),
                Divider(
                  color: MyColors.white.withValues(alpha: 0.1),
                  thickness: 1.h,
                ),
                SizedBox(height: 10.h),

                // Discount Code Section
                _buildDiscountCodeSection(paymentController),
                SizedBox(height: 10.h),
                Divider(
                  color: MyColors.white.withValues(alpha: 0.1),
                  thickness: 1.h,
                ),
                SizedBox(height: 10.h),

                // Payment Method Section
                _buildPaymentMethodSection(paymentController),
                SizedBox(height: 10.h),

                // Terms and Conditions
                _buildTermsCheckbox(paymentController),
                SizedBox(height: 20.h),

                // Security Indicator
                Align(
                  alignment: AlignmentGeometry.center,
                  child: _buildSecurityIndicator(),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailSection(PaymentController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order detail'.tr,
          style: AppTextStyles.heading1().copyWith(fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              '{${'Order:'.tr} } '.tr,
              style: AppTextStyles.bodyTextMedium16().copyWith(fontSize: 10.sp),
            ),
            Text(
              controller.orderPoints.value,
              style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            Text(
              '${'Order number:'.tr} '.tr,
              style: AppTextStyles.bodyTextMedium16().copyWith(fontSize: 10.sp),
            ),
            Text(
              '138973', //static
              // controller.orderNumber.value,
              style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscountCodeSection(PaymentController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Do you have a discount code?'.tr,
          style: AppTextStyles.heading1().copyWith(fontSize: 13.sp),
        ),
        SizedBox(height: 10.h),
        CustomTextfield(
          controller: _discountController,
          labelVisible: false,
          onChanged: (value) => controller.updateDiscountCode(value),
          hintText: 'Discount code'.tr,
        ),

        SizedBox(height: 10.h),
        CustomButton(
          text: 'Verify'.tr,
          onPressed: () => controller.verifyDiscountCode(),
          backgroundColor: MyColors.white.withValues(alpha: 0.05),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(PaymentController controller) {
    return Obx(() {
      if (controller.selectedPaymentMethod.value == null &&
          controller.paymentMethods.isNotEmpty) {
        Future.microtask(() {
          controller.selectedPaymentMethod.value =
              controller.paymentMethods.first;
        });
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method'.tr,
            style: AppTextStyles.heading1().copyWith(fontSize: 13.sp),
          ),
          SizedBox(height: 10.h),
          Column(
            children: List.generate(controller.paymentMethods.length, (index) {
              final method = controller.paymentMethods[index];
              final isSelected =
                  controller.selectedPaymentMethod.value?.id == method.id;

              Widget paymentImage;
              String lowerName = method.name?.toLowerCase() ?? '';
              String lowerId = method.id?.toLowerCase() ?? '';

              if (lowerName.contains('fato') || lowerId.contains('fato')) {
                paymentImage = Image.asset(
                  'assets/images/fatora.png',
                  width: 130,
                );
              } else if (lowerName.contains('upay') ||
                  lowerId.contains('upay')) {
                paymentImage = Image.asset(
                  'assets/images/upayment.png',
                  width: 130,
                );
              } else if (method.iconUrl != null && method.iconUrl!.isNotEmpty) {
                paymentImage = CachedNetworkImage(
                  imageUrl: method.iconUrl!,
                  width: 130,
                  errorWidget:
                      (context, url, error) => Text(
                        method.name ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                );
              } else {
                paymentImage = Text(
                  method.name ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: GestureDetector(
                  onTap: () {
                    // Always set to this method when tapped (no toggle-off)
                    controller.selectedPaymentMethod.value = method;
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? MyColors.greenColor.withValues(alpha: 0.1)
                              : MyColors.redButtonColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(80.r),
                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors:
                              isSelected
                                  ? [
                                    MyColors.greenColor.withValues(alpha: 0.1),
                                    MyColors.greenColor,
                                  ]
                                  : [
                                    MyColors.redButtonColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    MyColors.redButtonColor,
                                  ],
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (isSelected) ...[
                              SvgPicture.asset(
                                MyIcons.circle_check_outline,
                                height: 25.h,
                              ),
                              SizedBox(width: 10.w),
                            ] else ...[
                              SizedBox(width: 35.w),
                            ],
                          ],
                        ),
                        paymentImage,
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      );
    });
  }

  Widget _buildTermsCheckbox(PaymentController controller) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              controller.toggleTermsAccepted();
            },
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color:
                    controller.termsAccepted.value
                        ? MyColors.redButtonColor
                        : Colors.transparent,
                border: Border.all(color: MyColors.redButtonColor, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child:
                  controller.termsAccepted.value
                      ? Icon(Icons.check, size: 14.sp, color: MyColors.white)
                      : null,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyTextRegular16().copyWith(
                  fontSize: 12.sp,
                  color: MyColors.white.withValues(alpha: 0.7),
                ),
                children: [
                  TextSpan(text: 'I have read and agree to the '.tr),
                  TextSpan(
                    text: 'terms and conditions'.tr,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: MyColors.white,
                      color: MyColors.white,
                    ),
                  ),
                  TextSpan(text: '.'.tr),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(image: AssetImage(MyIcons.safegaurd), height: 60.h),
        SizedBox(height: 8.h),
        Text(
          'Secure payment and excellent customer service'.tr,
          style: AppTextStyles.heading2().copyWith(
            fontSize: 7.sp,
            color: MyColors.greenColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPaymentBar(BuildContext context) {
    final paymentController = Get.find<PaymentController>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(color: MyColors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${paymentController.totalAmount.value.toStringAsFixed(2)}',
                style: AppTextStyles.heading1().copyWith(
                  fontSize: 16.sp,
                  color: MyColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 2.w),
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  'KD'.tr,
                  style: AppTextStyles.heading2().copyWith(
                    fontSize: 10.sp,
                    color: MyColors.black.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          // Pay now button
          GestureDetector(
            onTap: () async {
              await paymentController.processPayment();
            },
            child: Container(
              width: 100.w,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: MyColors.redButtonColor,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Row(
                children: [
                  Spacer(flex: 6),
                  Text(
                    'Pay now'.tr,
                    style: AppTextStyles.heading2().copyWith(
                      fontSize: 10.sp,
                      color: MyColors.white,
                    ),
                  ),
                  Spacer(flex: 2),
                  Get.locale?.languageCode == 'en'
                      ? SvgPicture.asset(MyIcons.arrow_right)
                      : Icon(
                        Icons.arrow_forward_ios,
                        size: 15.sp,
                        color: Colors.white,
                      ),
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
