import 'package:flutter/material.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';

class AppInputDecorations {
  AppInputDecorations._();

  static InputDecoration authField({
    String? hintText,
    Widget? suffixIcon,
    String? counterText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.hint,
      fillColor: AppColors.thinGrey,
      filled: true,
      suffixIcon: suffixIcon,
      counterText: counterText,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
      border: _border,
      focusedErrorBorder: _border,
      focusedBorder: _border,
      enabledBorder: _border,
      isDense: true,
      isCollapsed: true,
    );
  }

  static final OutlineInputBorder _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(color: Colors.transparent, width: 0),
  );
}
