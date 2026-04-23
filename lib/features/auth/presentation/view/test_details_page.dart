import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testnow_mobile_app/app/router/app_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/app/theme/input_decorations.dart';
import 'package:testnow_mobile_app/app/utils/app_assets.dart';
import 'package:testnow_mobile_app/features/auth/domain/user_role.dart';
import 'package:testnow_mobile_app/features/auth/presentation/viewmodel/test_details_controller.dart';
import 'package:testnow_mobile_app/global_widgets/custom_app_bar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_primary_button.dart';

class TestDetailsPage extends ConsumerStatefulWidget {
  final UserRole role;
  const TestDetailsPage({super.key, required this.role});

  @override
  ConsumerState<TestDetailsPage> createState() => _TestDetailsPageState();
}

class _TestDetailsPageState extends ConsumerState<TestDetailsPage> {
  late final TextEditingController _theory;
  late final TextEditingController _licence;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(testDetailsControllerProvider);
    _theory = TextEditingController(text: initial.theoryTestNumber);
    _licence = TextEditingController(text: initial.drivingLicenceNumber);
  }

  @override
  void dispose() {
    _theory.dispose();
    _licence.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(testDetailsControllerProvider);
    final controller = ref.read(testDetailsControllerProvider.notifier);
    final isInstructor = widget.role == UserRole.instructor;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              90.verticalSpace,
              Image.asset(AppAssets.logo, scale: 4),
              Text('Test Details', style: AppTextStyles.style25Bold),
              20.verticalSpace,
              Text(
                isInstructor
                    ? "Enter the details of the student's booked test."
                    : 'Enter the details of your booked test.',
                style: AppTextStyles.style16.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              30.verticalSpace,
              _InputSection(
                label: 'Theory Test Number',
                hint: 'Enter Theory Test Number',
                controller: _theory,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                onChanged: controller.setTheory,
                helperText: state.theoryError ?? 'This 9 digit number is mandatory',
                isError: state.theoryError != null,
                tooltipMessage: 'Example: 123456789',
              ),
              20.verticalSpace,
              _InputSection(
                label: 'Driving Licence Number',
                hint: 'Enter full driving licence number (as shown on your licence)',
                controller: _licence,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  _UpperCaseFormatter(),
                  LengthLimitingTextInputFormatter(16),
                ],
                onChanged: controller.setLicence,
                helperText: state.licenceError ?? 'Eg: BEGUM060025R99BS',
                isError: state.licenceError != null,
                tooltipMessage: 'Example: BEGUM060025R99BS',
              ),
              60.verticalSpace,
              SizedBox(
                width: 354.w,
                height: 52.h,
                child: CustomPrimaryButton(
                  text: 'Next',
                  onPressed: state.isValid
                      ? () => context
                          .push('${AppRoutes.address}?role=${widget.role.name}')
                      : null,
                  boxColor: state.isValid
                      ? AppColors.primary
                      : AppColors.black.withValues(alpha: 0.03),
                  textColor:
                      state.isValid ? AppColors.white : AppColors.primary,
                ),
              ),
              40.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _InputSection extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String> onChanged;
  final String helperText;
  final bool isError;
  final String tooltipMessage;

  const _InputSection({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    required this.onChanged,
    required this.helperText,
    required this.isError,
    required this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.style17_600.copyWith(color: AppColors.primary),
        ),
        10.verticalSpace,
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          decoration: AppInputDecorations.authField(hintText: hint),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Tooltip(
                message: tooltipMessage,
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 3),
                child: Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 25.sp,
                ),
              ),
              5.horizontalSpace,
              Expanded(
                child: Text(
                  helperText,
                  style: AppTextStyles.style14.copyWith(
                    fontSize: 12.sp,
                    color: isError ? Colors.red : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
