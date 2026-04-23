import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testnow_mobile_app/app/router/app_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/app/utils/app_assets.dart';
import 'package:testnow_mobile_app/global_widgets/account_selection_card.dart';
import 'package:testnow_mobile_app/global_widgets/custom_app_bar.dart';

class TypeOfInstructorPage extends StatelessWidget {
  const TypeOfInstructorPage({super.key});

  void _next(BuildContext context) {
    context.push(AppRoutes.professionalDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              100.verticalSpace,
              Center(
                child: SizedBox(
                  width: 334.w,
                  height: 49.h,
                  child: Image.asset(AppAssets.cap),
                ),
              ),
              10.verticalSpace,
              Center(
                child: Text(
                  'What type of instructor are you?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.style25Bold,
                ),
              ),
              20.verticalSpace,
              Text(
                "It’s important that your selection matches your instructors badge.",
                style:
                    AppTextStyles.style16.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              30.verticalSpace,
              AccountSelectionCard(
                title: 'ADI',
                onTap: () => _next(context),
              ),
              3.verticalSpace,
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Approved Driving Instructor',
                  style: AppTextStyles.style14.copyWith(
                    color: AppColors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              29.verticalSpace,
              AccountSelectionCard(
                title: 'PDI',
                onTap: () => _next(context),
              ),
              3.verticalSpace,
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Potential Driving Instructor',
                  style: AppTextStyles.style14.copyWith(
                    color: AppColors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              200.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
