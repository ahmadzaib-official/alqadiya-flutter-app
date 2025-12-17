import 'package:alqadiya_game/core/utils/spacing.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/gradient_box_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextfield extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;
  final double? height;
  final double? fieldTextSize;
  final double? hintFontSize;
  final double? horizentalContentPadding;
  final EdgeInsetsGeometry? contentPadding;
  final double? width;
  final Color? color;
  final Color? hintTextColor;
  final Color? borderColor;
  final String? hintText;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final GestureTapCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool? labelVisible;
  final bool autoValidate;
  final String? errorText;
  final bool showErrorText;
  final AutovalidateMode? autovalidateMode;

  const CustomTextfield({
    super.key,
    this.label,
    this.borderColor = MyColors.redButtonColor,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefix,
    this.hintTextColor,
    this.suffix,
    this.inputFormatters,
    this.labelVisible,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
    this.validator,
    this.onTap,
    this.color,
    this.errorText,
    this.onChanged,
    this.minLines,
    this.maxLines,
    this.height,
    this.fieldTextSize = 15,
    this.hintFontSize,
    this.horizentalContentPadding,
    this.contentPadding,
    this.hintText,
    this.width,
    this.autoValidate = false,
    this.showErrorText = true,
    this.autovalidateMode,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  String? currentErrorText;
  bool hasInteracted = false;

  @override
  void initState() {
    super.initState();
    // Add listener to controller to validate on text changes
    widget.controller?.addListener(_validateField);
    widget.focusNode?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_validateField);
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.focusNode?.hasFocus == false) {
      // Field lost focus, mark as interacted
      setState(() {
        hasInteracted = true;
      });
      _validateField();
    }
  }

  void _validateField() {
    if (widget.validator != null && hasInteracted) {
      setState(() {
        currentErrorText = widget.validator!(widget.controller?.text);
      });
    }
  }

  // This method is called when form.validate() is called
  String? _formValidator(String? value) {
    setState(() {
      hasInteracted = true;
      currentErrorText = widget.validator?.call(value);
    });
    return currentErrorText;
    // return null;'
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelVisible ?? true) ...[
          Text(widget.label!, style: AppTextStyles.labelRegular14()),
          AppSizedBoxes.smallSizedBox,
        ],
        Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: GradientBoxBorder(
              gradient: LinearGradient(
                begin: AlignmentGeometry.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.borderColor!.withValues(alpha: 0.1),
                  widget.borderColor!,
                ],
              ),
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                spreadRadius: 0,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextFormField(
            obscuringCharacter: '*',
            inputFormatters: widget.inputFormatters,
            focusNode: widget.focusNode,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            enabled: widget.enabled,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            validator: _formValidator,
            autovalidateMode:
                widget.autovalidateMode ?? AutovalidateMode.disabled,
            style: AppTextStyles.bodyTextRegular16().copyWith(
              color: MyColors.white.withValues(alpha: 0.5),
              fontSize: widget.fieldTextSize!.sp,
            ),
            minLines: widget.obscureText ? 1 : widget.minLines,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            decoration: InputDecoration(
              filled: true,
              hintText: widget.hintText ?? '',
              hintStyle: AppTextStyles.labelRegular14().copyWith(
                fontSize:
                    widget.hintFontSize != null
                        ? widget.hintFontSize!.sp
                        : null,
                color:
                    widget.hintTextColor ??
                    MyColors.white.withValues(alpha: 0.5),
              ),
              fillColor:
                  widget.color ??
                  MyColors.redButtonColor.withValues(alpha: 0.1),
              contentPadding: EdgeInsets.symmetric(
                vertical: 14.h,
                horizontal: widget.horizentalContentPadding?.w ?? 12.w,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide.none,
              ),
              // errorBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(0.0),
              //   borderSide: BorderSide.none,
              //   gapPadding: 0,
              // ),
              error: null,
              errorMaxLines: 1,
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide.none,
              ),
              // Critical: disable error text spacing
              isCollapsed: false,
              prefixIcon: widget.prefix,
              suffixIcon: widget.suffix,
              errorText: null,
            ),
          ),
        ),
        if (widget.showErrorText &&
            currentErrorText != null &&
            currentErrorText!.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            currentErrorText!,
            style: AppTextStyles.captionRegular12().copyWith(
              fontSize: 11.sp,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}
