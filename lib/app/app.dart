import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testnow_mobile_app/app/router/app_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final router = ref.watch(goRouterProvider);
        return MaterialApp.router(
          title: 'TestNow',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            scaffoldBackgroundColor: AppColors.white,
            useMaterial3: true,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
