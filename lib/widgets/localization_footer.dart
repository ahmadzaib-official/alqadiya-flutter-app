import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/widgets/language_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Customizable footer widget that includes divider and LanguageSelectionButton
/// Can be used as a positioned widget or inline widget
class LocalizationFooter extends StatelessWidget {
  const LocalizationFooter({
    super.key,
    this.dividerPadding,
    this.dividerColor,
    this.showDivider = true,
    this.languageButtonHeight,
    this.languageButtonWidth,
    this.languageButtonMargin,
    this.languageButtonColor,
    this.languageButtonTextFontSize,
    this.languageButtonOnTap,
    this.spacingBetweenDividerAndButton,
    this.usePositioned = false,
    this.positionedBottom,
    this.positionedRight,
    this.alignment = Alignment.bottomRight,
    this.showDividerInColumn = false,
  });

  /// Padding around the divider
  final EdgeInsetsGeometry? dividerPadding;

  /// Color of the divider
  final Color? dividerColor;

  /// Whether to show the divider
  final bool showDivider;

  /// Height of the language selection button
  final double? languageButtonHeight;

  /// Width of the language selection button
  final double? languageButtonWidth;

  /// Margin of the language selection button
  final EdgeInsetsGeometry? languageButtonMargin;

  /// Color of the language selection button
  final Color? languageButtonColor;

  /// Text font size of the language selection button
  final double? languageButtonTextFontSize;

  /// OnTap callback for the language selection button
  final VoidCallback? languageButtonOnTap;

  /// Spacing between divider and language button
  final double? spacingBetweenDividerAndButton;

  /// Whether to use Positioned widget (for Stack) or inline widget
  final bool usePositioned;

  /// Bottom position when using Positioned widget
  final double? positionedBottom;

  /// Right position when using Positioned widget
  final double? positionedRight;

  /// Alignment when using inline widget (not positioned)
  final Alignment alignment;

  /// Whether to show divider in Column (for cases where divider is in Column and button is Positioned)
  final bool showDividerInColumn;

  /// Builds just the divider widget
  Widget buildDivider() {
    if (!showDivider) return SizedBox.shrink();

    return Divider(
      color: dividerColor ?? MyColors.white.withValues(alpha: 0.1),
    );
  }

  /// Builds just the language button widget
  Widget buildLanguageButton() {
    return LanguageSelectionButton(
      height: languageButtonHeight ?? 50.h,
      width: languageButtonWidth ?? 40.w,
      margin: languageButtonMargin ?? EdgeInsets.only(left: 12.w),
      color: languageButtonColor ?? MyColors.black.withValues(alpha: 0.2),
      textFontSize: languageButtonTextFontSize ?? 6.sp,
      onTap: languageButtonOnTap,
    );
  }

  /// Builds the footer content (divider + button) for inline use
  Widget _buildFooterContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDivider) buildDivider(),
        if (showDivider && spacingBetweenDividerAndButton != null)
          SizedBox(height: spacingBetweenDividerAndButton),
        if (!showDivider && spacingBetweenDividerAndButton != null)
          SizedBox(height: spacingBetweenDividerAndButton),
        Align(
          alignment: alignment,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
            child: buildLanguageButton(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (usePositioned) {
      return Align(
        alignment: AlignmentGeometry.centerRight,
        child: buildLanguageButton(),
      );
    }

    return _buildFooterContent();
  }
}
