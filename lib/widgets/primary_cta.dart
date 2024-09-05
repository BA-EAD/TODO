import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:to_do_app/utils/app_imports.dart';

class PrimaryCta extends StatelessWidget {
  final String text;
  final RichText? richText;
  final Widget? icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final TextStyle? textStyle;
  final bool filled;
  final bool outline;
  final bool fillWidth;
  final bool disabled;
  final Widget? child;
  final double? width;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Color? backgroundColor;
  final Color? textColor;
  final OutlinedBorder? outlinedBorder;
  final BorderRadius? borderRadius;
  final double? elevation;

  const PrimaryCta({
    required this.text,
    super.key,
    this.icon,
    this.onPressed,
    this.onLongPress,
    this.textStyle,
    this.filled = false,
    this.outline = false,
    this.fillWidth = false,
    this.width,
    this.richText,
    this.child,
    this.disabled = false,
    this.backgroundColor,
    this.textColor,
    this.verticalPadding,
    this.horizontalPadding,
    this.outlinedBorder,
    this.borderRadius,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: _getWidth(),
      child: TextButton(
        style: _style(isDarkMode),
        onPressed: disabled ? null : onPressed,
        onLongPress: disabled ? null : onLongPress,
        child: body(),
      ),
    );
  }

  Widget body() {
    if (child != null) return child!;
    if (icon != null) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 8,
          horizontal: horizontalPadding ?? 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _text(),
            Gap(8.0.w),
            icon!,
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding ?? 8,
        horizontal: horizontalPadding ?? 16,
      ),
      child: _text(),
    );
  }

  Widget _text() =>
      richText ?? Text(text, style: textStyle ?? TextStyle(color: textColor));

  ButtonStyle _style(bool isDarkMode) => TextButton.styleFrom(
        elevation: elevation ?? 0.0,
        disabledBackgroundColor:
            backgroundColor ?? AppColors.primaryColor.withOpacity(0.5),
        backgroundColor: filled
            ? backgroundColor ?? AppColors.primaryColor
            : Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        textStyle: GoogleFonts.getFont(AppStrings.fontName,
            fontWeight: FontWeight.w600, fontSize: 16),
        foregroundColor: isDarkMode || filled
            ? AppColors.blackTextColor
            : AppColors.blackTextColor,
        shape: _getShape(isDarkMode),
        // According to the material spec, disabled text should have an
        //opacity of 38%.
        // ref: https://m2.material.io/design/color/text-legibility.html#text-backgrounds
        disabledForegroundColor: (isDarkMode || filled
                ? AppColors.blackTextColor
                : AppColors.blackTextColor)
            .withOpacity(0.38),
      );

  OutlinedBorder? _getShape(bool isDarkMode) {
    if (outlinedBorder != null) return outlinedBorder;
    if (filled || outline) {
      return RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(30.0),
        side: outline
            ? BorderSide(
                color: backgroundColor != null
                    ? backgroundColor!
                    : AppColors.primaryColor,
              )
            : BorderSide.none,
      );
    }
    return null;
  }

  double? _getWidth() {
    if (width != null) return width;
    if (fillWidth) return double.infinity;
    return null;
  }
}
