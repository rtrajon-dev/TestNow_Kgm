import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'SF Pro';

  static TextStyle get style14 => TextStyle(
        fontSize: 14.sp,
        color: AppColors.black,
        fontWeight: FontWeight.w400,
        fontFamily: _fontFamily,
      );

  static TextStyle get style16 => TextStyle(
        fontSize: 16.sp,
        color: AppColors.black,
        fontWeight: FontWeight.w400,
        fontFamily: _fontFamily,
      );

  static TextStyle get style16Bold => TextStyle(
        fontSize: 16.sp,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontFamily: _fontFamily,
      );

  static TextStyle get style17_600 => TextStyle(
        fontSize: 17.sp,
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
        fontFamily: _fontFamily,
      );

  static TextStyle get style25Bold => TextStyle(
        fontSize: 25.sp,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontFamily: _fontFamily,
      );

  static TextStyle get style34_700 => TextStyle(
        fontSize: 34.sp,
        color: AppColors.black,
        fontWeight: FontWeight.w700,
        fontFamily: _fontFamily,
      );

  static TextStyle get hint => TextStyle(
        fontSize: 14.sp,
        color: AppColors.hintText,
        fontWeight: FontWeight.w300,
        fontFamily: _fontFamily,
      );
}
