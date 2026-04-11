import 'package:flutter/material.dart';
import 'package:read_lao/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:read_lao/utilities/provider/theme_provider.dart';
import 'package:read_lao/utilities/hive_utility.dart';
import 'package:read_lao/utilities/notification_utility.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.aboutThisApp),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.appTitle,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(l10n.aboutVersion),
                const SizedBox(height: 16),
                Text(l10n.aboutDescription1),
                const SizedBox(height: 16),
                Text(l10n.aboutDescription2),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }

  void _showResetConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final innerL10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(innerL10n.resetProgressTitle),
          content: Text(innerL10n.resetProgressContent),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(innerL10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                await HiveUtility.clearAllData();
                await NotificationUtility.cancelReminder();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(innerL10n.progressResetSuccessfully),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(innerL10n.reset, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingsTitle), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                final l10n = AppLocalizations.of(context)!;
                return SwitchListTile(
                  title: Text(
                    l10n.darkMode,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    themeProvider.isDarkMode
                        ? l10n.darkThemeEnabled
                        : l10n.lightThemeEnabled,
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  secondary: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    size: 28,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable:
                  Hive.box<dynamic>(HiveUtility.streakBox).listenable(),
              builder: (context, box, _) {
                final l10n = AppLocalizations.of(context)!;
                final enabled = HiveUtility.getNotificationsEnabled();
                return SwitchListTile(
                  title: Text(
                    l10n.dailyReminder,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    enabled
                        ? l10n.reminderEnabled
                        : l10n.reminderDisabled,
                  ),
                  value: enabled,
                  secondary: Icon(
                    enabled
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    size: 28,
                  ),
                  onChanged: (value) async {
                    if (value) {
                      final granted =
                          await NotificationUtility.requestPermission();
                      if (!granted) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.notificationPermissionDenied,
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                        return;
                      }
                      HiveUtility.setNotificationsEnabled(true);
                      await NotificationUtility.scheduleReminder();
                    } else {
                      HiveUtility.setNotificationsEnabled(false);
                      await NotificationUtility.cancelReminder();
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.info_outline, size: 28),
              title: Text(
                AppLocalizations.of(context)!.aboutThisApp,
                style: const TextStyle(fontSize: 18),
              ),
              onTap: () => _showAboutDialog(context),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(
                Icons.restart_alt,
                size: 28,
                color: Colors.red,
              ),
              title: Text(
                AppLocalizations.of(context)!.resetProgress,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
              onTap: () => _showResetConfirmDialog(context),
            ),
            // const SizedBox(height: 8),
            // ListTile(
            //   leading: const Icon(
            //     Icons.skip_next,
            //     size: 28,
            //     color: Colors.blue,
            //   ),
            //   title: const Text(
            //     'Skip to Lesson',
            //     style: TextStyle(fontSize: 18, color: Colors.blue),
            //   ),
            //   onTap: () => _showSkipToLessonDialog(context),
            // ),
            // if (kDebugMode) ...[
            //   const SizedBox(height: 16),
            //   Consumer<DebugProvider>(
            //     builder: (context, debugProvider, child) {
            //       return SwitchListTile(
            //         title: const Text(
            //           'Show Exercise Incrementor',
            //           style: TextStyle(fontSize: 18),
            //         ),
            //         subtitle: Text(
            //           debugProvider.showExerciseIncrementor
            //               ? 'Exercise navigation visible'
            //               : 'Exercise navigation hidden',
            //         ),
            //         value: debugProvider.showExerciseIncrementor,
            //         onChanged: (value) {
            //           debugProvider.toggleShowExerciseIncrementor();
            //         },
            //         secondary: const Icon(Icons.navigation, size: 28),
            //       );
            //     },
            //   ),
            //   const SizedBox(height: 8),
            //   ListTile(
            //     leading: const Icon(
            //       Icons.check_circle,
            //       size: 28,
            //       color: Colors.green,
            //     ),
            //     title: const Text(
            //       'Mark All Lessons Complete',
            //       style: TextStyle(fontSize: 18, color: Colors.green),
            //     ),
            //     onTap: () => _showMarkAllCompleteDialog(context),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
