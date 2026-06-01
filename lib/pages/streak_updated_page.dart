import 'package:flutter/material.dart';
import 'package:read_lao/components/animal_illustration.dart';
import 'package:read_lao/l10n/app_localizations.dart';

class StreakUpdatedPage extends StatelessWidget {
  final int streak;
  final Widget nextPage;

  const StreakUpdatedPage({
    super.key,
    required this.streak,
    required this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AnimalIllustration(
              asset: 'assets/animals/tiger.svg',
              size: 160,
            ),
            const SizedBox(height: 8),
            Text(
              '🔥',
              style: TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.streakDays(streak),
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              streak == 1
                  ? AppLocalizations.of(context)!.streakStarted
                  : AppLocalizations.of(context)!.streakContinue,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
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
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              label: Text(
                AppLocalizations.of(context)!.continueButton,
                style: TextStyle(
                  fontSize: theme.textTheme.headlineSmall?.fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
