import 'package:flutter/material.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: Colors.black87),
            SizedBox(width: 4),
            Text(
              'Back',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isActive;

  const FilterButton({super.key, this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : AppColors.black.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          'Filter',
          style: TextStyle(
            color: isActive ? AppColors.white : const Color(0xFF333333),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class NotificationButton extends StatelessWidget {
  final VoidCallback? onTap;

  const NotificationButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.notifications, color: Colors.white, size: 24),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackTap;
  final bool showBackButton;
  final bool isDashboard;
  final VoidCallback? onFilterTap;
  final VoidCallback? onNotificationTap;
  final bool filterActive;

  const CustomAppBar({
    super.key,
    this.title,
    this.onBackTap,
    this.showBackButton = true,
    this.isDashboard = false,
    this.onFilterTap,
    this.onNotificationTap,
    this.filterActive = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leading;
    if (isDashboard && onFilterTap != null) {
      leading = FilterButton(onTap: onFilterTap, isActive: filterActive);
    } else if (showBackButton) {
      leading = CustomBackButton(onTap: onBackTap);
    }

    return AppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 100,
      leading: leading != null
          ? Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Center(child: leading),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          : null,
      actions: [
        if (isDashboard)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: NotificationButton(onTap: onNotificationTap),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
