import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:read_lao/utilities/achievement_data.dart';
import 'package:read_lao/utilities/hive_utility.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable:
            Hive.box<dynamic>(HiveUtility.achievementsBox).listenable(),
        builder: (context, box, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              Text(
                'Achievements',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(title: 'Streak Milestones'),
              const SizedBox(height: 8),
              ...AchievementData.streakAchievements.map(
                (a) => _AchievementTile(achievement: a),
              ),
              const SizedBox(height: 24),
              _SectionHeader(title: 'Lesson Milestones'),
              const SizedBox(height: 8),
              ...AchievementData.lessonAchievements.map(
                (a) => _AchievementTile(achievement: a),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

String _formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final unlockDate = HiveUtility.getAchievementUnlockDate(achievement.id);
    final isUnlocked = unlockDate != null;
    final theme = Theme.of(context);
    final lockedColor = theme.colorScheme.onSurface.withValues(alpha: 0.38);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Text(
          achievement.emoji,
          style: TextStyle(
            fontSize: 28,
            color: isUnlocked ? null : lockedColor,
          ),
        ),
        title: Text(
          achievement.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isUnlocked ? null : lockedColor,
          ),
        ),
        subtitle: Text(
          isUnlocked
              ? 'Unlocked ${_formatDate(unlockDate)}'
              : achievement.description,
          style: TextStyle(
            color: isUnlocked ? theme.colorScheme.primary : lockedColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
