import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastUtility {
  static void show(
    BuildContext context,
    String message, {
    Toast length = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.CENTER,
  }) {
    final theme = Theme.of(context);

    // Get theme colors
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor =
        (isDark ? theme.colorScheme.surface : theme.colorScheme.primary)
            .withValues(alpha: 0.9);
    final textColor = isDark
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.onPrimary;

    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: theme.textTheme.headlineMedium?.fontSize,
    );
  }
}
