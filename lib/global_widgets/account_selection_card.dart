import 'package:flutter/material.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';

class AccountSelectionCard extends StatelessWidget {
  final String title;
  final ImageProvider? image;
  final IconData? icon;
  final VoidCallback onTap;

  const AccountSelectionCard({
    super.key,
    required this.title,
    this.image,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            if (icon != null)
              const Icon(Icons.school_rounded,
                  size: 28, color: AppColors.primary)
            else if (image != null)
              Image(image: image!, width: 28, height: 28),
            if (icon != null || image != null) const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
