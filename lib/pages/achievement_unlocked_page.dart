import 'package:flutter/material.dart';
import 'package:read_lao/utilities/achievement_data.dart';

class AchievementUnlockedPage extends StatelessWidget {
  final List<Achievement> achievements;
  final Widget nextPage;

  const AchievementUnlockedPage({
    super.key,
    required this.achievements,
    required this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSingle = achievements.length == 1;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events_rounded,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                isSingle ? 'Achievement Unlocked!' : 'Achievements Unlocked!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ...achievements.map(
                (a) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(a.emoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                a.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => nextPage),
                  );
                },
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  size: theme.textTheme.headlineSmall?.fontSize,
                ),
                iconAlignment: IconAlignment.end,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                label: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: theme.textTheme.headlineSmall?.fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
