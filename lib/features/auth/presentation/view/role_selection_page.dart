import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testnow_mobile_app/app/router/app_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/app/utils/app_assets.dart';
import 'package:testnow_mobile_app/features/auth/domain/user_role.dart';
import 'package:testnow_mobile_app/global_widgets/account_selection_card.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  void _goToLogin(BuildContext context, UserRole role) {
    context.push('${AppRoutes.login}?role=${role.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              200.verticalSpace,
              Center(
                child: Image.asset(AppAssets.icon, scale: 4),
              ),
              10.verticalSpace,
              Text('Welcome to TestNow', style: AppTextStyles.style25Bold),
              20.verticalSpace,
              Text(
                'Please select the most appropriate account type, Are you a ....',
                style: AppTextStyles.style16
                    .copyWith(color: AppColors.lightGrey.withValues(alpha: 0.60)),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              AccountSelectionCard(
                title: 'Student',
                image: const AssetImage(AppAssets.logo),
                onTap: () => _goToLogin(context, UserRole.student),
              ),
              20.verticalSpace,
              AccountSelectionCard(
                title: 'Instructor',
                icon: Icons.school_rounded,
                image: const AssetImage(AppAssets.logo),
                onTap: () => _goToLogin(context, UserRole.instructor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
