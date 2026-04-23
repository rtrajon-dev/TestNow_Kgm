import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/app/utils/app_assets.dart';
import 'package:testnow_mobile_app/features/student/domain/booking.dart';
import 'package:testnow_mobile_app/features/student/presentation/viewmodel/tests_controller.dart';
import 'package:testnow_mobile_app/global_widgets/app_snackbar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_app_bar.dart';

class TestsPage extends ConsumerWidget {
  const TestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testsControllerProvider);
    final controller = ref.read(testsControllerProvider.notifier);
    final bookings = ref
        .watch(mockBookingsProvider)
        .where((b) => b.status == state.selectedStatus)
        .toList();

    final groups = _groupBookings(bookings, state.filterSort);

    return Scaffold(
      appBar: CustomAppBar(
        isDashboard: true,
        showBackButton: false,
        filterActive: state.filterMenuOpen,
        onFilterTap: controller.toggleFilterMenu,
        onNotificationTap: () => AppSnackbar.show(
          context,
          title: 'Alerts coming soon',
          kind: SnackbarKind.info,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.filterMenuOpen)
              _FilterMenu(
                current: state.filterSort,
                onSelect: controller.setSort,
              ),
            Text(
              'Tests',
              style:
                  AppTextStyles.style34_700.copyWith(color: AppColors.primary),
            ),
            Text(
              'Select a test below from the DVSA or TestNow users',
              style: AppTextStyles.style14.copyWith(color: Colors.grey),
            ),
            10.verticalSpace,
            _StatusSegmented(
              selected: state.selectedStatus,
              onSelect: controller.selectStatus,
            ),
            20.verticalSpace,
            Expanded(
              child: bookings.isEmpty
                  ? Center(
                      child: Text(
                        _emptyMessage(state.selectedStatus),
                        style: AppTextStyles.style14.copyWith(
                          color: Colors.grey,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 100.h),
                      itemCount: groups.length,
                      itemBuilder: (context, i) {
                        final entry = groups.entries.elementAt(i);
                        return _BookingGroup(
                          header: entry.key,
                          items: entry.value,
                          status: state.selectedStatus,
                          sort: state.filterSort,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _emptyMessage(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'No pending tests';
      case BookingStatus.approved:
        return 'No approved tests';
      case BookingStatus.available:
        return 'No available tests';
    }
  }

  Map<String, List<Booking>> _groupBookings(
    List<Booking> bookings,
    TestsFilterSort sort,
  ) {
    final result = <String, List<Booking>>{};
    for (final b in bookings) {
      final key = switch (sort) {
        TestsFilterSort.location => b.location.split(',').first.trim(),
        TestsFilterSort.time => DateFormat('HH:mm').format(b.dateTime),
        TestsFilterSort.date => DateFormat('EEE d MMM').format(b.dateTime),
      };
      result.putIfAbsent(key, () => []).add(b);
    }
    return result;
  }
}

class _StatusSegmented extends StatelessWidget {
  final BookingStatus selected;
  final ValueChanged<BookingStatus> onSelect;

  const _StatusSegmented({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('Available', BookingStatus.available),
        5.horizontalSpace,
        _chip('Pending', BookingStatus.pending),
        5.horizontalSpace,
        _chip('Approved', BookingStatus.approved),
      ],
    );
  }

  Widget _chip(String label, BookingStatus value) {
    final active = selected == value;
    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary
              : AppColors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.style14.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _FilterMenu extends StatelessWidget {
  final TestsFilterSort current;
  final ValueChanged<TestsFilterSort> onSelect;

  const _FilterMenu({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: 250,
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20.r),
              border:
                  Border.all(color: AppColors.white.withValues(alpha: 0.65)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _option(TestsFilterSort.location, AppAssets.location,
                    'Location'),
                _option(TestsFilterSort.time, AppAssets.clock, 'Time'),
                _option(TestsFilterSort.date, AppAssets.date, 'Date'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _option(TestsFilterSort mode, String icon, String label) {
    final active = current == mode;
    final color = active ? AppColors.primary : AppColors.black;
    return InkWell(
      onTap: () => onSelect(mode),
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            child: Image.asset(icon, width: 20.w, height: 20.w),
          ),
          6.verticalSpace,
          Text(
            label,
            style: AppTextStyles.style14.copyWith(
              fontSize: 12.sp,
              color: color,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingGroup extends StatelessWidget {
  final String header;
  final List<Booking> items;
  final BookingStatus status;
  final TestsFilterSort sort;

  const _BookingGroup({
    required this.header,
    required this.items,
    required this.status,
    required this.sort,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sort == TestsFilterSort.date
              ? DateFormat('EEE d MMM').format(items.first.dateTime)
              : header,
          style: AppTextStyles.style16.copyWith(
            fontSize: 20.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        ...items.asMap().entries.expand((e) => [
              _BookingRow(item: e.value, status: status, sort: sort),
              if (e.key < items.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Colors.grey.withValues(alpha: 0.4),
                ),
            ]),
        const Divider(height: 16, thickness: 0.5),
        5.verticalSpace,
      ],
    );
  }
}

class _BookingRow extends StatelessWidget {
  final Booking item;
  final BookingStatus status;
  final TestsFilterSort sort;

  const _BookingRow({
    required this.item,
    required this.status,
    required this.sort,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppSnackbar.show(
        context,
        title: 'Coming soon',
        message: 'Tapped ${item.typeLabel}',
        kind: SnackbarKind.info,
      ),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(top: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      item.type == BookingType.dvsa
                          ? Image.asset(AppAssets.logo, scale: 10)
                          : Icon(Icons.swap_horiz,
                              size: 20.sp, color: Colors.green),
                      6.horizontalSpace,
                      Text(
                        item.typeLabel,
                        style: AppTextStyles.style14.copyWith(
                          fontWeight: FontWeight.w600,
                          color: item.type == BookingType.dvsa
                              ? Colors.purple
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  if (sort == TestsFilterSort.location) ...[
                    _dateRow(),
                    6.verticalSpace,
                    _timeRow(),
                  ] else if (sort == TestsFilterSort.time) ...[
                    _dateRow(emphasize: true),
                    6.verticalSpace,
                    _locationRow(),
                  ] else ...[
                    _timeRow(emphasize: true),
                    6.verticalSpace,
                    _locationRow(),
                  ],
                ],
              ),
            ),
            _rightBadge(),
          ],
        ),
      ),
    );
  }

  Widget _rightBadge() {
    switch (status) {
      case BookingStatus.available:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            item.buttonLabel,
            style: AppTextStyles.style14.copyWith(
              fontSize: 15.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      case BookingStatus.pending:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule, size: 16.sp, color: AppColors.primary),
              6.horizontalSpace,
              Text(
                item.pendingBadgeLabel,
                style: AppTextStyles.style14.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      case BookingStatus.approved:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline,
                  size: 16.sp, color: AppColors.green),
              6.horizontalSpace,
              Text(
                item.approvedBadgeLabel,
                style: AppTextStyles.style14.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _dateRow({bool emphasize = false}) {
    return Row(
      children: [
        Image.asset(
          AppAssets.date,
          scale: 5,
          color: emphasize ? AppColors.black : null,
        ),
        8.horizontalSpace,
        Text(
          DateFormat('EEE d MMM').format(item.dateTime),
          style: AppTextStyles.style17_600.copyWith(
            color: AppColors.black,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _timeRow({bool emphasize = false}) {
    final iconColor = emphasize ? AppColors.black : Colors.grey;
    return Row(
      children: [
        Image.asset(AppAssets.clock, scale: 5, color: iconColor),
        8.horizontalSpace,
        Text(
          DateFormat('HH:mm').format(item.dateTime),
          style: AppTextStyles.style14.copyWith(
            fontSize: 15.sp,
            color: emphasize ? AppColors.black : Colors.grey,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _locationRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Image.asset(AppAssets.location, scale: 5, color: Colors.grey),
        ),
        8.horizontalSpace,
        Expanded(
          child: Text(
            item.location,
            style: AppTextStyles.style17_600.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
