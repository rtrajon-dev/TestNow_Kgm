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

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackTap;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    this.title,
    this.onBackTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 100,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Center(child: CustomBackButton(onTap: onBackTap)),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
