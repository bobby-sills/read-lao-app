import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_lao/utilities/provider/theme_provider.dart';
import 'package:read_lao/utilities/provider/debug_provider.dart';
import 'package:read_lao/utilities/hive_utility.dart';
import 'package:read_lao/utilities/lesson_data.dart';

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
              child: const Text('Reset', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showMarkAllCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mark All Lessons Complete?'),
          content: const Text(
            'This will mark all lessons as complete, allowing you to access and test any lesson.',
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
                await HiveUtility.markAllLessonsComplete(
                  LessonData.allLessons.length,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All lessons marked as complete'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text(
                'Mark Complete',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSkipToLessonDialog(BuildContext context) {
    int selectedLevel = 0;
    final totalLessons = LessonData.allLessons.length;
    final consonantLessonsCount = LessonData.consonantLessons.length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String getLessonLabel(int index) {
              if (index < consonantLessonsCount) {
                return 'Consonant lesson $index';
              } else {
                return 'Vowel lesson $index';
              }
            }

            return AlertDialog(
              title: const Text('Skip to Lesson'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select a lesson to skip to. All previous lessons will be marked as complete.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      width: double.maxFinite,
                      child: ListView.builder(
                        itemCount: totalLessons,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(getLessonLabel(index)),
                            leading: Radio<int>(
                              value: index,
                              groupValue: selectedLevel,
                              onChanged: (value) {
                                setState(() {
                                  selectedLevel = value ?? 0;
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                selectedLevel = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
                    await HiveUtility.skipToLesson(selectedLevel);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Skipped to ${getLessonLabel(selectedLevel)}',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text('Skip to Level'),
                ),
              ],
            );
          },
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
            //   const SizedBox(height: 8),
            //   ListTile(
            //     leading: const Icon(
            //       Icons.restart_alt,
            //       size: 28,
            //       color: Colors.red,
            //     ),
            //     title: const Text(
            //       'Reset Progress',
            //       style: TextStyle(fontSize: 18, color: Colors.red),
            //     ),
            //     onTap: () => _showResetConfirmDialog(context),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
