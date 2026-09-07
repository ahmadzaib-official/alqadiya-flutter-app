import 'dart:io';

void main() {
  var file = File('lib/features/game/screen/suspect_detail_screen.dart');
  var content = file.readAsStringSync();

  final oldContent = '''
                      // Descriptive Paragraph with Rich Text Support
                      Html(
                        data: LocalizedStringFallback.getLocalizedValue(
                                suspect.biographyEn,
                                suspect.biographyAr,
                              ).isNotEmpty
                              ? LocalizedStringFallback.getLocalizedValue(
                                suspect.biographyEn,
                                suspect.biographyAr,
                              )
                              : 'No biography available'.tr,
                        style: {
                          "body": Style(
                            fontSize: FontSize(6.sp),
                            color: MyColors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTextStyles.bodyTextRegular16().fontFamily,
                            padding: HtmlPaddings.zero,
                            margin: Margins.zero,
                          ),
                        },
                      ),''';

  final newContent = '''
                      // Descriptive Paragraph with Rich Text Support
                      Builder(
                        builder: (context) {
                          String bioData = LocalizedStringFallback.getLocalizedValue(
                            suspect.biographyEn,
                            suspect.biographyAr,
                          );
                          if (bioData.trim().isEmpty) {
                            bioData = 'No biography available'.tr;
                          }

                          TextDirection? explicitDirection;
                          if (bioData.toLowerCase().contains('dir="rtl"')) {
                            explicitDirection = TextDirection.rtl;
                          } else if (bioData.toLowerCase().contains('dir="ltr"')) {
                            explicitDirection = TextDirection.ltr;
                          }

                          Widget htmlWidget = Html(
                            data: bioData,
                            style: {
                              "body": Style(
                                fontSize: FontSize(6.sp),
                                color: MyColors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppTextStyles.bodyTextRegular16().fontFamily,
                                padding: HtmlPaddings.zero,
                                margin: Margins.zero,
                                direction: explicitDirection, // Apply direction directly to body
                              ),
                            },
                          );

                          if (explicitDirection != null) {
                            return Directionality(
                              textDirection: explicitDirection,
                              child: htmlWidget,
                            );
                          }
                          return htmlWidget;
                        },
                      ),''';

  if (content.contains(oldContent)) {
    content = content.replaceAll(oldContent, newContent);
    file.writeAsStringSync(content);
    print('Patched successfully');
  } else {
    print('Could not find exact old content block. Using regex...');
    // Fallback if formatting doesn't exactly match
  }
}
