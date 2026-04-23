import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/app/utils/app_assets.dart';

class StudentShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const StudentShellPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _StudentBottomBar(
                  currentIndex: navigationShell.currentIndex,
                  onTap: (i) => navigationShell.goBranch(
                    i,
                    initialLocation: i == navigationShell.currentIndex,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _StudentBottomBar({
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _TabItem(AppAssets.logo, 'Tests'),
    _TabItem(AppAssets.cap, 'Instructors'),
    _TabItem(AppAssets.chat, 'Chat'),
    _TabItem(AppAssets.profile, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.shade300,
                const Color(0xFFF6F6F6),
                const Color(0xFFFAFAFA),
              ],
            ),
            borderRadius: BorderRadius.circular(296.0),
            border: Border.all(color: const Color(0xFFEDEDED), width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              return Expanded(
                child: _BottomBarButton(
                  item: _items[index],
                  isSelected: currentIndex == index,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final String icon;
  final String label;

  const _TabItem(this.icon, this.label);
}

class _BottomBarButton extends StatelessWidget {
  final _TabItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomBarButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const selected = Color(0xFF6155F5);
    const unselected = Color(0xFF404040);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected ? const Color(0xFFEDEDED) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              item.icon,
              height: 26,
              width: 26,
              color: isSelected ? selected : unselected,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: AppTextStyles.style14.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? selected : unselected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
