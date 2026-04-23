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
import 'package:testnow_mobile_app/features/auth/presentation/viewmodel/about_controller.dart';
import 'package:testnow_mobile_app/global_widgets/app_snackbar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_app_bar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_primary_button.dart';

class AboutPage extends ConsumerStatefulWidget {
  final UserRole role;
  const AboutPage({super.key, required this.role});

  @override
  ConsumerState<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> {
  late final TextEditingController _fullName;
  late final TextEditingController _houseNumber;
  late final TextEditingController _street;
  late final TextEditingController _town;
  late final TextEditingController _postcode;
  late final TextEditingController _drivingLicence;
  late final TextEditingController _prn;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(aboutControllerProvider);
    _fullName = TextEditingController(text: initial.fullName);
    _houseNumber = TextEditingController(text: initial.houseNumber);
    _street = TextEditingController(text: initial.street);
    _town = TextEditingController(text: initial.town);
    _postcode = TextEditingController(text: initial.postcode);
    _drivingLicence = TextEditingController(text: initial.drivingLicence);
    _prn = TextEditingController(text: initial.prn);
  }

  @override
  void dispose() {
    _fullName.dispose();
    _houseNumber.dispose();
    _street.dispose();
    _town.dispose();
    _postcode.dispose();
    _drivingLicence.dispose();
    _prn.dispose();
    super.dispose();
  }

  void _syncFromState(AboutFormState s) {
    _setIfChanged(_houseNumber, s.houseNumber);
    _setIfChanged(_street, s.street);
    _setIfChanged(_town, s.town);
    _setIfChanged(_postcode, s.postcode);
    _setIfChanged(_drivingLicence, s.drivingLicence);
  }

  void _setIfChanged(TextEditingController c, String value) {
    if (c.text == value) return;
    c.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AboutFormState>(aboutControllerProvider, (prev, next) {
      _syncFromState(next);
    });

    final state = ref.watch(aboutControllerProvider);
    final controller = ref.read(aboutControllerProvider.notifier);
    final isStudent = widget.role == UserRole.student;
    final isValid = state.isValid(widget.role);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppAssets.profile, scale: 4),
              10.verticalSpace,
              Text('About you', style: AppTextStyles.style25Bold),
              10.verticalSpace,
              Text(
                isStudent
                    ? 'Enter your student name, address and postcode to continue to next step to create your account'
                    : "Enter your instructor's name, driving licence number and PRN number to continue to next step to create your account",
                style: AppTextStyles.style16.copyWith(
                  color: AppColors.lightGrey.withValues(alpha: 0.60),
                ),
                textAlign: TextAlign.center,
              ),
              30.verticalSpace,
              _LabeledField(
                label: 'Full name',
                error: state.fullNameError,
                child: TextField(
                  controller: _fullName,
                  onChanged: controller.setFullName,
                  decoration: AppInputDecorations.authField(hintText: 'John Doe'),
                ),
              ),
              16.verticalSpace,
              if (isStudent) ...[
                _UseLocationButton(
                  isLoading: state.isLoadingLocation,
                  onTap: () async {
                    await controller.useCurrentLocation();
                    if (!context.mounted) return;
                    AppSnackbar.show(
                      context,
                      title: 'Location Found',
                      message: 'Address auto-filled (stubbed).',
                      kind: SnackbarKind.success,
                    );
                  },
                ),
                20.verticalSpace,
                _LabeledField(
                  label: 'House Number',
                  error: state.houseNumberError,
                  child: TextField(
                    controller: _houseNumber,
                    onChanged: controller.setHouseNumber,
                    decoration: AppInputDecorations.authField(hintText: '12'),
                  ),
                ),
                16.verticalSpace,
                _LabeledField(
                  label: 'Street',
                  error: state.streetError,
                  child: TextField(
                    controller: _street,
                    onChanged: controller.setStreet,
                    decoration:
                        AppInputDecorations.authField(hintText: 'Lynton Rd'),
                  ),
                ),
                16.verticalSpace,
                _LabeledField(
                  label: 'Town/City',
                  error: state.townError,
                  child: TextField(
                    controller: _town,
                    onChanged: controller.setTown,
                    decoration: AppInputDecorations.authField(hintText: 'London'),
                  ),
                ),
                16.verticalSpace,
                _LabeledField(
                  label: 'Postcode',
                  error: state.postcodeError,
                  child: TextField(
                    controller: _postcode,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [_UpperCaseFormatter()],
                    onChanged: controller.setPostcode,
                    decoration:
                        AppInputDecorations.authField(hintText: 'SE11 8AB'),
                  ),
                ),
              ] else ...[
                _LabeledField(
                  label: 'Driving Licence Number',
                  error: state.drivingLicenceError,
                  child: TextField(
                    controller: _drivingLicence,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [_UpperCaseFormatter()],
                    onChanged: controller.setDrivingLicence,
                    decoration:
                        AppInputDecorations.authField(hintText: 'AB123456C'),
                  ),
                ),
                16.verticalSpace,
                _LabeledField(
                  label: 'PRN Number',
                  error: state.prnError,
                  child: TextField(
                    controller: _prn,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: controller.setPrn,
                    decoration:
                        AppInputDecorations.authField(hintText: '123456'),
                  ),
                ),
              ],
              100.verticalSpace,
            ],
          ),
        ),
      ),
      bottomSheet: isValid
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              color: AppColors.white,
              child: CustomPrimaryButton(
                text: 'Next',
                onPressed: () {
                  if (widget.role == UserRole.student) {
                    context.push(
                      '${AppRoutes.testDetails}?role=${widget.role.name}',
                    );
                  } else {
                    context.push(AppRoutes.typeOfInstructor);
                  }
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String? error;
  final Widget child;

  const _LabeledField({
    required this.label,
    this.error,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(label, style: AppTextStyles.style17_600),
        ),
        6.verticalSpace,
        child,
        if (error != null) ...[
          5.verticalSpace,
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              error!,
              style: AppTextStyles.style14.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _UseLocationButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _UseLocationButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.thinGrey
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: isLoading ? Colors.grey : AppColors.primary,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else
              const Icon(Icons.location_on,
                  color: AppColors.primary, size: 20),
            8.horizontalSpace,
            Text(
              isLoading ? 'Getting location...' : 'Use Current Location',
              style: AppTextStyles.style17_600.copyWith(
                color: isLoading ? Colors.grey : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
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
