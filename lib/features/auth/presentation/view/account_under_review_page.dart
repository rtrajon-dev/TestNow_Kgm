import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testnow_mobile_app/app/router/app_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/features/auth/domain/user_role.dart';

class AccountUnderReviewPage extends StatefulWidget {
  final UserRole role;
  final Duration duration;

  const AccountUnderReviewPage({
    super.key,
    required this.role,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AccountUnderReviewPage> createState() => _AccountUnderReviewPageState();
}

class _AccountUnderReviewPageState extends State<AccountUnderReviewPage> {
  Timer? _timer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, () {
      if (!mounted || _navigated) return;
      _navigated = true;
      context.go('${AppRoutes.status}?role=${widget.role.name}');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goBack() {
    if (_navigated) return;
    _navigated = true;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.roleSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = widget.role == UserRole.student;
    final reviewMessage = isStudent
        ? "Your student account is being manually verified by our team. We'll notify you once your details have been approved."
        : "Your instructor profile is being manually verified by our team. We'll notify you once your credentials have been approved.";

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              12.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: _goBack,
                  borderRadius: BorderRadius.circular(28.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios_new,
                            size: 16.sp, color: AppColors.black),
                        8.horizontalSpace,
                        Text(
                          'Back',
                          style: AppTextStyles.style16.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 32,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.policy,
                    size: 46.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
              28.verticalSpace,
              Text(
                'Account Under Manual\nReview',
                textAlign: TextAlign.center,
                style: AppTextStyles.style25Bold.copyWith(
                  fontSize: 28.sp,
                  height: 1.15,
                ),
              ),
              14.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  reviewMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.style16.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.45,
                  ),
                ),
              ),
              28.verticalSpace,
              SizedBox(
                width: 34.w,
                height: 34.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.primary,
                ),
              ),
              12.verticalSpace,
              Text(
                'Under review...',
                style: AppTextStyles.style14.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
              const Spacer(),
              18.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
