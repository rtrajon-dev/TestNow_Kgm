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
import 'package:testnow_mobile_app/features/auth/domain/address.dart';
import 'package:testnow_mobile_app/features/auth/presentation/viewmodel/previous_address_controller.dart';
import 'package:testnow_mobile_app/global_widgets/app_snackbar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_app_bar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_primary_button.dart';

class PreviousAddressPage extends ConsumerWidget {
  const PreviousAddressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(previousAddressControllerProvider);
    final controller = ref.read(previousAddressControllerProvider.notifier);
    final allValid = controller.allValid;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            40.verticalSpace,
            Center(child: Image.asset(AppAssets.icon, scale: 4)),
            10.verticalSpace,
            Text(
              'Previous UK Addresses',
              textAlign: TextAlign.center,
              style: AppTextStyles.style25Bold,
            ),
            10.verticalSpace,
            Text(
              'Please provide your previous UK addresses from the past 5 years. Add another address using the + button.',
              textAlign: TextAlign.center,
              style: AppTextStyles.style16.copyWith(
                color: AppColors.lightGrey.withValues(alpha: 0.60),
              ),
            ),
            30.verticalSpace,
            for (var i = 0; i < entries.length; i++) ...[
              _AddressFormRow(
                key: ValueKey('prev-addr-$i'),
                index: i,
                canRemove: entries.length > 1,
              ),
              30.verticalSpace,
            ],
            100.verticalSpace,
          ],
        ),
      ),
      bottomSheet: allValid
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              color: AppColors.white,
              child: CustomPrimaryButton(
                text: 'Next',
                onPressed: () => context.go(AppRoutes.choosePlan),
              ),
            )
          : const SizedBox.shrink(),
      floatingActionButton: entries.length < kMaxPreviousAddresses
          ? FloatingActionButton(
              onPressed: controller.addEntry,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

class _AddressFormRow extends ConsumerStatefulWidget {
  final int index;
  final bool canRemove;

  const _AddressFormRow({
    super.key,
    required this.index,
    required this.canRemove,
  });

  @override
  ConsumerState<_AddressFormRow> createState() => _AddressFormRowState();
}

class _AddressFormRowState extends ConsumerState<_AddressFormRow> {
  late final TextEditingController _house;
  late final TextEditingController _street;
  late final TextEditingController _town;
  late final TextEditingController _postcode;

  @override
  void initState() {
    super.initState();
    final initial =
        ref.read(previousAddressControllerProvider)[widget.index].address;
    _house = TextEditingController(text: initial.houseNumber);
    _street = TextEditingController(text: initial.street);
    _town = TextEditingController(text: initial.town);
    _postcode = TextEditingController(text: initial.postcode);
  }

  @override
  void dispose() {
    _house.dispose();
    _street.dispose();
    _town.dispose();
    _postcode.dispose();
    super.dispose();
  }

  void _syncFrom(Address a) {
    _setIfChanged(_house, a.houseNumber);
    _setIfChanged(_street, a.street);
    _setIfChanged(_town, a.town);
    _setIfChanged(_postcode, a.postcode);
  }

  void _setIfChanged(TextEditingController c, String v) {
    if (c.text == v) return;
    c.value = TextEditingValue(
      text: v,
      selection: TextSelection.collapsed(offset: v.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<List<PreviousAddressEntry>>(
      previousAddressControllerProvider,
      (prev, next) {
        if (widget.index >= next.length) return;
        _syncFrom(next[widget.index].address);
      },
    );

    final entries = ref.watch(previousAddressControllerProvider);
    if (widget.index >= entries.length) return const SizedBox.shrink();
    final entry = entries[widget.index];
    final controller = ref.read(previousAddressControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Previous Address ${widget.index + 1}',
                style: AppTextStyles.style25Bold.copyWith(fontSize: 20.sp),
              ),
              if (widget.canRemove)
                IconButton(
                  tooltip: 'Remove address',
                  onPressed: () => controller.removeEntry(widget.index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),
        ),
        _UseLocationButton(
          isLoading: entry.isLoadingLocation,
          onTap: () async {
            await controller.useCurrentLocation(widget.index);
            if (!context.mounted) return;
            AppSnackbar.show(
              context,
              title: 'Location Found',
              message:
                  'Address ${widget.index + 1} auto-filled (stubbed).',
              kind: SnackbarKind.success,
            );
          },
        ),
        16.verticalSpace,
        _Labeled(
          label: 'House Number',
          error: entry.houseNumberError,
          child: TextField(
            controller: _house,
            onChanged: (v) =>
                controller.updateField(widget.index, houseNumber: v),
            decoration: AppInputDecorations.authField(hintText: '12'),
          ),
        ),
        16.verticalSpace,
        _Labeled(
          label: 'Street',
          error: entry.streetError,
          child: TextField(
            controller: _street,
            onChanged: (v) => controller.updateField(widget.index, street: v),
            decoration: AppInputDecorations.authField(hintText: 'Lynton Rd'),
          ),
        ),
        16.verticalSpace,
        _Labeled(
          label: 'Town/City',
          error: entry.townError,
          child: TextField(
            controller: _town,
            onChanged: (v) => controller.updateField(widget.index, town: v),
            decoration: AppInputDecorations.authField(hintText: 'London'),
          ),
        ),
        16.verticalSpace,
        _Labeled(
          label: 'Postcode',
          error: entry.postcodeError,
          child: TextField(
            controller: _postcode,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [_UpperCaseFormatter()],
            onChanged: (v) =>
                controller.updateField(widget.index, postcode: v),
            decoration: AppInputDecorations.authField(hintText: 'SE11 8AB'),
          ),
        ),
      ],
    );
  }
}

class _Labeled extends StatelessWidget {
  final String label;
  final String? error;
  final Widget child;

  const _Labeled({
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
