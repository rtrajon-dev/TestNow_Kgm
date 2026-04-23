import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:testnow_mobile_app/app/router/app_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/app/utils/app_assets.dart';
import 'package:testnow_mobile_app/features/auth/domain/user_role.dart';
import 'package:testnow_mobile_app/global_widgets/custom_primary_button.dart';

class StatusPage extends StatelessWidget {
  final UserRole role;

  const StatusPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isStudent = role == UserRole.student;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Image.asset(
                  AppAssets.profile,
                  width: 334.w,
                  height: 80.h,
                ),
              ),
              2.verticalSpace,
              Text(
                'We\u2019re still verifying your details',
                style: AppTextStyles.style25Bold,
                textAlign: TextAlign.center,
              ),
              10.verticalSpace,
              Text(
                isStudent
                    ? "We'll send you a notification once your account has been activated."
                    : "You'll be notified once your account is approved.",
                style: AppTextStyles.style16.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SpinKitFadingCircle(
                    color: AppColors.greyBorder,
                    size: 30.0,
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      isStudent
                          ? 'Verifying Driving Test'
                          : 'Validating Your Information',
                      style: AppTextStyles.style17_600.copyWith(
                        fontSize: 15.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              CustomPrimaryButton(
                text: 'Ok',
                onPressed: () {
                  context.go(AppRoutes.studentTests);
                },
              ),
              40.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
