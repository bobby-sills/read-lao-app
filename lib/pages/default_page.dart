import 'package:flutter/material.dart';
import 'package:read_lao/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:read_lao/pages/achievements_page.dart';
import 'package:read_lao/pages/lessons_page.dart' show HomePage;
import 'package:read_lao/pages/practice_page.dart';
import 'package:read_lao/pages/settings_page.dart';
import 'package:read_lao/utilities/hive_utility.dart';
import 'package:read_lao/utilities/notification_utility.dart';

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
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    if (HiveUtility.isFirstLaunch()) {
      final granted = await NotificationUtility.requestPermission();
      HiveUtility.setNotificationsEnabled(granted);
      HiveUtility.markFirstLaunchDone();
    }
    await NotificationUtility.scheduleReminder();
  }

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
        destinations: [
          NavigationDestination(
            selectedIcon: const Icon(Icons.home_rounded),
            icon: const Icon(Icons.home_outlined),
            label: AppLocalizations.of(context)!.lessonsNavLabel,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.edit_rounded),
            icon: const Icon(Icons.edit_outlined),
            label: AppLocalizations.of(context)!.practiceNavLabel,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.emoji_events_rounded),
            icon: const Icon(Icons.emoji_events_outlined),
            label: AppLocalizations.of(context)!.achievementsNavLabel,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.settings_rounded),
            icon: const Icon(Icons.settings_outlined),
            label: AppLocalizations.of(context)!.settingsNavLabel,
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
                    builder: (_) {
                      final l10n = AppLocalizations.of(context)!;
                      return AlertDialog(
                        contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                        content: Text(
                          streak == 0
                              ? l10n.streakDialogNoStreak
                              : streak == 1
                                  ? l10n.streakDialogOneDay
                                  : l10n.streakDialogMultipleDays(streak),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(streak == 0 ? l10n.streakDialogButtonNoStreak : l10n.streakDialogButtonWithStreak),
                          ),
                        ],
                      );
                    },
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
