import 'package:flutter/material.dart';

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
            Text(
              '🔥',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            Text(
              '$streak day streak!',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              streak == 1
                  ? 'You\'ve started your streak — come back tomorrow!'
                  : 'Amazing consistency. Keep it going!',
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
                'Continue',
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
