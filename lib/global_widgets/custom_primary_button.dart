import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? fontSize;
  final double? height;
  final Color? boxColor;
  final Color? textColor;
  final ImageProvider? image;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.fontSize,
    this.image,
    this.boxColor,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return GestureDetector(
      onTap: disabled || isLoading ? null : onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: boxColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(25.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        height: height ?? 60.h,
        child: isLoading
            ? SizedBox(
                height: 42.h,
                width: 42.w,
                child: const CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (image != null) ...[
                    Image(
                      image: image!,
                      height: fontSize != null ? fontSize! + 4 : 20.h,
                      color: textColor ?? AppColors.white,
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.style16.copyWith(
                      color: textColor ?? AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
