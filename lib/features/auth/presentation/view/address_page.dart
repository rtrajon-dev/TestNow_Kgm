import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testnow_mobile_app/app/router/app_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/app/utils/app_assets.dart';
import 'package:testnow_mobile_app/features/auth/domain/user_role.dart';
import 'package:testnow_mobile_app/global_widgets/app_snackbar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_app_bar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_primary_button.dart';

class AddressPage extends StatefulWidget {
  final UserRole role;
  const AddressPage({super.key, required this.role});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  String? _selected; // 'yes' or 'no'

  void _onNext() {
    if (_selected == null) {
      AppSnackbar.show(
        context,
        title: 'Please select an option',
        message: 'You must select an option to continue',
        kind: SnackbarKind.error,
      );
      return;
    }
    if (_selected == 'yes') {
      context.push(AppRoutes.previousAddress);
    } else {
      context.go(AppRoutes.choosePlan);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selected != null;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                80.verticalSpace,
                Center(child: Image.asset(AppAssets.icon, scale: 4)),
                10.verticalSpace,
                Text(
                  'Do you have any previous UK addresses? ',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.style25Bold,
                ),
                10.verticalSpace,
                Text(
                  'We need your address history for the past 5 years if you want your instructor to manage your driving test for you.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.style16.copyWith(
                    color: AppColors.lightGrey.withValues(alpha: 0.60),
                  ),
                ),
                const Spacer(),
                _OptionRow(
                  label: 'Yes',
                  labelColor: AppColors.primary,
                  trailing: _selected == 'yes'
                      ? Image.asset(AppAssets.check,
                          width: 20.w, height: 20.h)
                      : SizedBox(width: 20.w, height: 20.h),
                  onTap: () => setState(() => _selected = 'yes'),
                ),
                20.verticalSpace,
                _OptionRow(
                  label: 'No',
                  labelColor: Colors.redAccent,
                  trailing: _selected == 'no'
                      ? Image.asset(AppAssets.cross,
                          width: 20.w, height: 20.h)
                      : SizedBox(width: 20.w, height: 20.h),
                  onTap: () => setState(() => _selected = 'no'),
                ),
                70.verticalSpace,
                CustomPrimaryButton(
                  text: 'Next',
                  textColor:
                      hasSelection ? AppColors.white : AppColors.primary,
                  boxColor: hasSelection
                      ? AppColors.primary
                      : AppColors.black.withValues(alpha: 0.03),
                  onPressed: _onNext,
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Widget trailing;
  final VoidCallback onTap;

  const _OptionRow({
    required this.label,
    required this.labelColor,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.thinGrey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.style17_600.copyWith(color: labelColor),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
