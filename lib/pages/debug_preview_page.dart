import 'package:flutter/material.dart';
import 'package:read_lao/pages/achievement_unlocked_page.dart';
import 'package:read_lao/pages/empty_lesson.dart';
import 'package:read_lao/pages/lesson_complete.dart';
import 'package:read_lao/pages/streak_updated_page.dart';
import 'package:read_lao/utilities/achievement_data.dart';

class DebugPreviewPage extends StatelessWidget {
  const DebugPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = <_PreviewEntry>[
      _PreviewEntry(
        label: 'Lesson Complete',
        builder: (_) => const LessonComplete(lessonNum: 4),
      ),
      _PreviewEntry(
        label: 'Streak Updated (1 day)',
        builder: (_) =>
            const StreakUpdatedPage(streak: 1, nextPage: _PreviewDoneScreen()),
      ),
      _PreviewEntry(
        label: 'Streak Updated (7 days)',
        builder: (_) =>
            const StreakUpdatedPage(streak: 7, nextPage: _PreviewDoneScreen()),
      ),
      _PreviewEntry(
        label: 'Achievement Unlocked (single)',
        builder: (_) => AchievementUnlockedPage(
          achievements: [AchievementData.streakAchievements.first],
          nextPage: const _PreviewDoneScreen(),
        ),
      ),
      _PreviewEntry(
        label: 'Achievement Unlocked (multiple)',
        builder: (_) => AchievementUnlockedPage(
          achievements: AchievementData.streakAchievements.take(3).toList(),
          nextPage: const _PreviewDoneScreen(),
        ),
      ),
      _PreviewEntry(
        label: 'Empty Lesson',
        builder: (_) => const EmptyLesson(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Preview Screens'), centerTitle: true),
      body: ListView.separated(
        itemCount: entries.length,
        separatorBuilder: (_, i) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final entry = entries[i];
          return ListTile(
            title: Text(entry.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: entry.builder),
            ),
          );
        },
      ),
    );
  }
}

class _PreviewEntry {
  final String label;
  final WidgetBuilder builder;
  const _PreviewEntry({required this.label, required this.builder});
}

class _PreviewDoneScreen extends StatelessWidget {
  const _PreviewDoneScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Preview flow complete'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
