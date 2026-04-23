import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testnow_mobile_app/app/router/app_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/app/utils/app_assets.dart';
import 'package:testnow_mobile_app/features/auth/domain/user_role.dart';
import 'package:testnow_mobile_app/features/auth/presentation/viewmodel/choose_plan_controller.dart';
import 'package:testnow_mobile_app/global_widgets/custom_app_bar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_primary_button.dart';

class ChoosePlanPage extends ConsumerWidget {
  const ChoosePlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(choosePlanControllerProvider);
    final controller = ref.read(choosePlanControllerProvider.notifier);
    final plan = state.currentPlan;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h, child: Image.asset(AppAssets.plan)),
              Text('Choose your plan', style: AppTextStyles.style25Bold),
              10.verticalSpace,
              Text(
                'We have different features on offer depending on your tier.',
                textAlign: TextAlign.center,
                style: AppTextStyles.style16.copyWith(color: Colors.grey),
              ),
              30.verticalSpace,
              _PlanSelector(
                selectedIndex: state.selectedIndex,
                onSelect: controller.selectPlan,
              ),
              30.verticalSpace,
              Text(
                plan.price,
                style: AppTextStyles.style34_700.copyWith(color: Colors.blue),
              ),
              if (plan.subtitle.isNotEmpty) ...[
                5.verticalSpace,
                Text(
                  plan.subtitle,
                  style: AppTextStyles.style17_600
                      .copyWith(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
              30.verticalSpace,
              ...plan.features.map(_FeatureItem.new),
              100.verticalSpace,
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        child: CustomPrimaryButton(
          text: plan.buttonText,
          onPressed: () {
            if (plan.title == 'Free') {
              context.go('${AppRoutes.status}?role=${UserRole.student.name}');
            } else {
              _showPaymentBottomSheet(context);
            }
          },
        ),
      ),
    );
  }

  void _showPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _PaymentSheet(),
    );
  }
}

class _PlanSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _PlanSelector({required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(25.r),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(plans.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  plans[index].title,
                  style: AppTextStyles.style16Bold.copyWith(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final PlanFeature feature;
  const _FeatureItem(this.feature);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            _buildIcon(),
            12.horizontalSpace,
            Expanded(
              child: Text(
                feature.text,
                style: AppTextStyles.style17_600.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (!feature.isIncluded) {
      return Image.asset(AppAssets.cross, scale: 4);
    }
    if (feature.isYellow) {
      return Image.asset(AppAssets.bell, scale: 4);
    }
    return Image.asset(AppAssets.check, scale: 4);
  }
}

class _PaymentSheet extends ConsumerWidget {
  const _PaymentSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(choosePlanControllerProvider);
    final controller = ref.read(choosePlanControllerProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'Select Payment Method',
              style: AppTextStyles.style25Bold,
            ),
          ),
          20.verticalSpace,
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                _PaymentOption(
                  id: 'apple',
                  icon: Icons.apple,
                  title: 'Apple Card',
                  subtitle: 'Pay with Apple Card',
                  selected: state.selectedPaymentMethod == 'apple',
                  onTap: () => controller.selectPaymentMethod('apple'),
                ),
                _PaymentOption(
                  id: 'billing',
                  icon: Icons.credit_card,
                  title: 'Billing Details',
                  subtitle: 'Enter card details',
                  selected: state.selectedPaymentMethod == 'billing',
                  onTap: () => controller.selectPaymentMethod('billing'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: CustomPrimaryButton(
              text: 'Next',
              textColor: state.selectedPaymentMethod != null
                  ? AppColors.white
                  : AppColors.primary,
              boxColor: state.selectedPaymentMethod != null
                  ? AppColors.primary
                  : AppColors.black.withValues(alpha: 0.03),
              onPressed: state.selectedPaymentMethod != null
                  ? () {
                      Navigator.pop(context);
                      context
                          .go('${AppRoutes.status}?role=${UserRole.student.name}');
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.thinGrey,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 24, color: Colors.black),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.style17_600),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: AppTextStyles.style14
                        .copyWith(color: AppColors.lightGrey),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle,
                  color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
