import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:testnow_mobile_app/app/router/app_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/app/utils/app_assets.dart';
import 'package:testnow_mobile_app/features/auth/presentation/viewmodel/professional_details_controller.dart';
import 'package:testnow_mobile_app/global_widgets/custom_app_bar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_primary_button.dart';

class ProfessionalDetailsPage extends ConsumerStatefulWidget {
  const ProfessionalDetailsPage({super.key});

  @override
  ConsumerState<ProfessionalDetailsPage> createState() =>
      _ProfessionalDetailsPageState();
}

class _ProfessionalDetailsPageState
    extends ConsumerState<ProfessionalDetailsPage> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickBadgeImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    ref
        .read(professionalDetailsControllerProvider.notifier)
        .setBadgeImage(image.path);
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final sixMonthsAhead = DateTime(now.year, now.month + 6, now.day);
    final current = ref.read(professionalDetailsControllerProvider).expiryDate;
    final initial = (current != null && current.isBefore(sixMonthsAhead))
        ? current
        : now;

    final picked = await showDatePicker(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      initialDate: initial,
      firstDate: now,
      lastDate: sixMonthsAhead,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;
    ref
        .read(professionalDetailsControllerProvider.notifier)
        .setExpiryDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(professionalDetailsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.verticalSpace,
              SizedBox(
                width: 334.w,
                height: 49.h,
                child: Image.asset(AppAssets.idc),
              ),
              10.verticalSpace,
              Center(
                child: Text(
                  'Professional details',
                  style: AppTextStyles.style25Bold,
                ),
              ),
              10.verticalSpace,
              Center(
                child: Text(
                  'Enter your professional details so we can verify your credentials.',
                  style: AppTextStyles.style16
                      .copyWith(color: AppColors.lightGrey),
                  textAlign: TextAlign.center,
                ),
              ),
              30.verticalSpace,
              Text('Instructor Badge', style: AppTextStyles.style17_600),
              6.verticalSpace,
              GestureDetector(
                onTap: _pickBadgeImage,
                child: Container(
                  width: 334.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.thinGrey,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(AppAssets.cam,
                                width: 44.w, height: 44.h),
                            Text(
                              state.badgeImagePath != null
                                  ? 'Badge Uploaded'
                                  : 'Upload Badge',
                              style: AppTextStyles.style17_600
                                  .copyWith(color: AppColors.black),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.check_circle,
                          color: state.badgeImagePath != null
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.badgeImagePath != null) ...[
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  height: 100.h,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    image: DecorationImage(
                      image: FileImage(File(state.badgeImagePath!)),
                      fit: BoxFit.cover,
                    ),
                    color: AppColors.thinGrey,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
              ],
              16.verticalSpace,
              Text('Badge expiry date', style: AppTextStyles.style17_600),
              6.verticalSpace,
              GestureDetector(
                onTap: _pickExpiryDate,
                child: Container(
                  width: 334.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.thinGrey,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.expiryDate != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(state.expiryDate!)
                              : 'DD/MM/YYYY',
                          style: AppTextStyles.style17_600.copyWith(
                            color: state.expiryDate != null
                                ? AppColors.black
                                : Colors.grey,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              100.verticalSpace,
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        color: AppColors.white,
        child: CustomPrimaryButton(
          text: 'Next',
          textColor: state.isValid ? AppColors.white : AppColors.primary,
          boxColor: state.isValid
              ? AppColors.primary
              : AppColors.black.withValues(alpha: 0.03),
          onPressed: state.isValid
              ? () => context.push(AppRoutes.choosePlan)
              : null,
        ),
      ),
    );
  }
}
