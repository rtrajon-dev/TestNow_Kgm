import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/app/utils/app_assets.dart';
import 'package:testnow_mobile_app/global_widgets/app_snackbar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_app_bar.dart';

class _MockInstructor {
  final String name;
  final String location;
  const _MockInstructor(this.name, this.location);
}

const _current = _MockInstructor('James Mitchell', 'London, UK');
const _requests = <_MockInstructor>[
  _MockInstructor('Sarah Hughes', 'Hendon, London'),
];
const _previous = <_MockInstructor>[
  _MockInstructor('David Clarke', 'Isleworth, London'),
];

class InstructorsPage extends StatelessWidget {
  const InstructorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isDashboard: true,
        showBackButton: false,
        onNotificationTap: () => AppSnackbar.show(
          context,
          title: 'Alerts coming soon',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 110.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instructors',
                style: AppTextStyles.style34_700
                    .copyWith(color: AppColors.primary),
              ),
              10.verticalSpace,
              Text(
                'Manage your instructors here',
                style: AppTextStyles.style14
                    .copyWith(fontSize: 15.sp, color: Colors.grey),
              ),
              20.verticalSpace,
              _InstructorCard(
                instructor: _current,
                status: 'Current instructor',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconButton(context, Icons.settings_outlined),
                    8.horizontalSpace,
                    _iconButton(context, Icons.chat_bubble_outline),
                    8.horizontalSpace,
                    _iconButton(context, Icons.refresh),
                  ],
                ),
              ),
              40.verticalSpace,
              Text(
                'My requests',
                style: AppTextStyles.style25Bold.copyWith(
                  fontSize: 22.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.verticalSpace,
              Text(
                'Here’s where you’ll find driving instructor requests',
                style: AppTextStyles.style14
                    .copyWith(fontSize: 15.sp, color: Colors.grey),
              ),
              20.verticalSpace,
              if (_requests.isEmpty)
                const _EmptyState(
                  title: 'No requests',
                  subtitle:
                      'When you request a new instructor, it will show here.',
                )
              else
                ..._requests.map(
                  (req) => Padding(
                    padding: EdgeInsets.only(bottom: 14.h),
                    child: _InstructorCard(
                      instructor: req,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _actionCircle(
                            context,
                            Colors.redAccent.withValues(alpha: 0.15),
                            AppAssets.cross,
                          ),
                          10.horizontalSpace,
                          _actionCircle(
                            context,
                            AppColors.primary.withValues(alpha: 0.15),
                            AppAssets.check,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              40.verticalSpace,
              Text(
                'Previous instructors',
                style: AppTextStyles.style25Bold.copyWith(
                  fontSize: 22.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.verticalSpace,
              Text(
                'View your booking and message history here',
                style: AppTextStyles.style14
                    .copyWith(fontSize: 15.sp, color: Colors.grey),
              ),
              20.verticalSpace,
              if (_previous.isEmpty)
                const _EmptyState(
                  title: 'No previous instructors',
                  subtitle: 'Your previous instructors will appear here.',
                )
              else
                ..._previous.map(
                  (ins) => Padding(
                    padding: EdgeInsets.only(bottom: 14.h),
                    child: _InstructorCard(instructor: ins),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon) {
    return InkWell(
      onTap: () => AppSnackbar.show(context, title: 'Coming soon'),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18.sp, color: AppColors.primary),
      ),
    );
  }

  Widget _actionCircle(BuildContext context, Color bg, String icon) {
    return InkWell(
      onTap: () => AppSnackbar.show(context, title: 'Coming soon'),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Image.asset(icon, width: 20.w, height: 20.h),
      ),
    );
  }
}

class _InstructorCard extends StatelessWidget {
  final _MockInstructor instructor;
  final String? status;
  final Widget? trailing;

  const _InstructorCard({
    required this.instructor,
    this.status,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.primary,
            child: Text(
              instructor.name[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  instructor.name,
                  style: AppTextStyles.style17_600
                      .copyWith(color: AppColors.black),
                ),
                2.verticalSpace,
                Text(
                  instructor.location,
                  style: AppTextStyles.style14.copyWith(
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                ),
                if (status != null) ...[
                  4.verticalSpace,
                  Text(
                    status!,
                    style: AppTextStyles.style14.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                AppTextStyles.style17_600.copyWith(color: AppColors.black),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyles.style14
                .copyWith(fontSize: 15.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
