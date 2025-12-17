// change_language_screen.dart
import 'package:alqadiya_game/core/utils/spacing.dart';
import 'package:alqadiya_game/features/change_language/controller/language_controller.dart';
import 'package:alqadiya_game/widgets/app_bar.dart';
import 'package:alqadiya_game/features/change_language/widgets/custom_selector.dart';
import 'package:alqadiya_game/core/services/localization_services.dart';
import 'package:alqadiya_game/core/services/refresh_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageChangeScreen extends StatelessWidget {
  const LanguageChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeLanguageController());

    return Scaffold(
      appBar: CustomAppBar( showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: controller.languageList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final language = controller.languageList[index];
            return Obx(
              () => ListTile(
                contentPadding: EdgeInsets.zero,

                title: Row(
                  children: [
                    SvgPicture.asset(
                      language.image ?? '',
                      width: 28.w,
                      height: 28.h,
                    ),
                    AppSizedBoxes.smallWidthSizedBox,
                    Text(
                      language.title ?? '',
                      style: GoogleFonts.getFont(
                        (index == 1) ? 'Cairo' : 'Cairo',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                trailing: GestureDetector(
                  onTap: () async {
                    // Get.find<HomeScreenController>().fetchProperties(
                    //   language: language.slug!,
                    // );
                    // Get.find<LoyalityController>().fetchRewards(language.slug!);
                    // Get.find<BookingController>().fetchBookings(language.slug!);
                  },
                  child: CustomRadioMedium(
                    isSelected:
                        controller.selectedLanguage.value.slug == language.slug,
                  ),
                ),
                splashColor: Colors.transparent,

                onTap: () async {
                  await controller.changeLanguage(language);
                  await LocalizationService().changeLocale(language.slug!);
                  Get.updateLocale(Locale(language.slug!));

                  await RefreshService.refreshAll();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
