import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_lao/utilities/provider/theme_provider.dart';
import 'package:read_lao/utilities/hive_utility.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About this app'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Learn Lao',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Version 1.0.0'),
                SizedBox(height: 16),
                Text(
                  'An interactive app for learning the Lao language through engaging exercises and lessons.',
                ),
                SizedBox(height: 16),
                Text(
                  'Learn to recognize, pronounce, and write Lao letters at your own pace.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
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
        return AlertDialog(
          title: const Text('Reset Progress?'),
          content: const Text(
            'This will reset all lesson progress. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await HiveUtility.clearAllData();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Progress reset successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    themeProvider.isDarkMode
                        ? 'Dark theme enabled'
                        : 'Light theme enabled',
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
            ListTile(
              leading: const Icon(Icons.info_outline, size: 28),
              title: const Text(
                'About this app',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () => _showAboutDialog(context),
            ),
            if (kDebugMode) ...[
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.restart_alt, size: 28, color: Colors.red),
                title: const Text(
                  'Reset Progress',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                onTap: () => _showResetConfirmDialog(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
