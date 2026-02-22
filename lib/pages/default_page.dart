import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:read_lao/pages/achievements_page.dart';
import 'package:read_lao/pages/lessons_page.dart' show HomePage;
import 'package:read_lao/pages/practice_page.dart';
import 'package:read_lao/pages/settings_page.dart';
import 'package:read_lao/utilities/hive_utility.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _StreakBadge extends StatelessWidget {
  final int streak;

  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '🔥 $streak',
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DefaultPageState extends State<DefaultPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home_rounded),
            icon: Icon(Icons.home_outlined),
            label: "Lessons",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.edit_rounded),
            icon: Icon(Icons.edit_outlined),
            label: "Practice",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.emoji_events_rounded),
            icon: Icon(Icons.emoji_events_outlined),
            label: 'Achievements',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings_rounded),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: Stack(
        children: [
          <Widget>[
            const HomePage(),
            const PracticePage(),
            const AchievementsPage(),
            const SettingsPage(),
          ][currentPageIndex],
          ValueListenableBuilder(
            valueListenable:
                Hive.box<dynamic>(HiveUtility.streakBox).listenable(),
            builder: (context, box, _) {
              if (currentPageIndex == 3) return const SizedBox.shrink();
              final streak = HiveUtility.getCurrentStreak();
              return Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 16,
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      content: Text(
                        streak == 0
                            ? 'Complete a lesson today to start your streak!'
                            : 'You have practiced for $streak ${streak == 1 ? 'day' : 'days'} in a row!',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(streak == 0 ? "Let's go!" : 'Nice!'),
                        ),
                      ],
                    ),
                  ),
                  child: _StreakBadge(streak: streak),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
