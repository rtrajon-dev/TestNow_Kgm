import 'package:flutter/material.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';

enum SnackbarKind { info, success, warning, error }

class AppSnackbar {
  AppSnackbar._();

  static void show(
    BuildContext context, {
    required String title,
    String? message,
    SnackbarKind kind = SnackbarKind.info,
  }) {
    final color = switch (kind) {
      SnackbarKind.success => Colors.green,
      SnackbarKind.warning => Colors.orange,
      SnackbarKind.error => Colors.redAccent,
      SnackbarKind.info => AppColors.primary,
    };
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 2),
              Text(message, style: const TextStyle(color: Colors.white)),
            ],
          ],
        ),
      ),
    );
  }
}
