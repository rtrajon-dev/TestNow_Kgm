import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testnow_mobile_app/app/router/app_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/global_widgets/app_snackbar.dart';

class _MockProfile {
  final String name;
  final String currentAddress;
  final String previousAddress;
  final String theoryTestNumber;
  final String drivingLicenseNumber;
  final String bookingRefNumber;
  final String testDateTime;
  final String primaryTestCentre;
  final bool isTestSwapsEnabled;

  const _MockProfile({
    required this.name,
    required this.currentAddress,
    required this.previousAddress,
    required this.theoryTestNumber,
    required this.drivingLicenseNumber,
    required this.bookingRefNumber,
    required this.testDateTime,
    required this.primaryTestCentre,
    required this.isTestSwapsEnabled,
  });
}

const _profile = _MockProfile(
  name: 'Rajon Reza',
  currentAddress: '12 Lynton Rd, London SE11 8AB',
  previousAddress: '47 Harrow Rd, London NW1 6XE',
  theoryTestNumber: '123456789',
  drivingLicenseNumber: 'REZA060025R99BS',
  bookingRefNumber: 'TN-2026-04128',
  testDateTime: '2026-05-12 09:30',
  primaryTestCentre: 'Isleworth Test Centre',
  isTestSwapsEnabled: true,
);

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  bool _swapsEnabled = _profile.isTestSwapsEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: InkWell(
          onTap: () => context.go(AppRoutes.roleSelection),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Log out',
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.style17_600.copyWith(color: Colors.grey),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () =>
                AppSnackbar.show(context, title: 'Settings coming soon'),
            child: Icon(Icons.settings_outlined,
                color: Colors.grey, size: 24.sp),
          ),
          15.horizontalSpace,
          InkWell(
            onTap: () =>
                AppSnackbar.show(context, title: 'Alerts coming soon'),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.notifications,
                  color: Colors.white, size: 20),
            ),
          ),
          16.horizontalSpace,
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                'Profile',
                style: AppTextStyles.style34_700
                    .copyWith(color: AppColors.primary),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                'Here are the details we have linked to you',
                style: AppTextStyles.style14
                    .copyWith(fontSize: 15.sp, color: Colors.grey),
              ),
            ),
            20.verticalSpace,
            _Section(label: 'Name', value: _profile.name),
            const _Divider(),
            _Section(
              label: 'Current Address',
              value: _profile.currentAddress,
              actionText: 'Edit',
              onActionTap: () =>
                  AppSnackbar.show(context, title: 'Edit coming soon'),
            ),
            const _Divider(),
            _Section(
              label: 'Previous Address',
              value: _profile.previousAddress,
              showArrow: true,
              onRowTap: () =>
                  context.push(AppRoutes.previousAddress),
            ),
            const _Divider(),
            _Section(
                label: 'Theory Test Number',
                value: _profile.theoryTestNumber),
            const _Divider(),
            _Section(
                label: 'Driving License Number',
                value: _profile.drivingLicenseNumber),
            const _Divider(),
            _Section(
                label: 'Booking Test Reference Number',
                value: _profile.bookingRefNumber),
            const _Divider(),
            _Section(
                label: 'Date and time of test', value: _profile.testDateTime),
            const _Divider(),
            _Section(
              label: 'Primary Test Centre',
              value: _profile.primaryTestCentre,
              actionText: 'Edit',
              onActionTap: () =>
                  AppSnackbar.show(context, title: 'Edit coming soon'),
            ),
            const _Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Additional test centres',
                          style: AppTextStyles.style17_600
                              .copyWith(color: AppColors.black)),
                      4.verticalSpace,
                      Text(
                        'Upgrade to access',
                        style: AppTextStyles.style14
                            .copyWith(fontSize: 15.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => context.push(AppRoutes.choosePlan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                      minimumSize: Size(0, 32.h),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_upward,
                            size: 14, color: Colors.white),
                        5.horizontalSpace,
                        Text(
                          'Upgrade',
                          style: AppTextStyles.style14.copyWith(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const _Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Test swaps and discoverability',
                            style: AppTextStyles.style17_600
                                .copyWith(color: AppColors.black)),
                        5.verticalSpace,
                        Text(
                          'Allow tests to be swapped and accessed by instructors and students.',
                          style: AppTextStyles.style14
                              .copyWith(fontSize: 15.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  10.horizontalSpace,
                  Switch(
                    value: _swapsEnabled,
                    activeThumbColor: AppColors.primary,
                    onChanged: (v) => setState(() => _swapsEnabled = v),
                  ),
                ],
              ),
            ),
            120.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String label;
  final String value;
  final String? actionText;
  final bool showArrow;
  final VoidCallback? onActionTap;
  final VoidCallback? onRowTap;

  const _Section({
    required this.label,
    required this.value,
    this.actionText,
    this.showArrow = false,
    this.onActionTap,
    this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: InkWell(
        onTap: onRowTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.style17_600
                          .copyWith(color: AppColors.black)),
                  4.verticalSpace,
                  Text(
                    value,
                    style: AppTextStyles.style14
                        .copyWith(fontSize: 15.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (actionText != null)
              TextButton(
                onPressed: onActionTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionText!,
                  style: AppTextStyles.style14.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (showArrow)
              Icon(Icons.keyboard_arrow_down,
                  color: AppColors.primary, size: 24.sp),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1.h, thickness: 1, color: Colors.grey.shade200);
  }
}
