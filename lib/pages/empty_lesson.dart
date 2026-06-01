import 'package:flutter/material.dart';
import 'package:read_lao/components/animal_illustration.dart';
import 'package:read_lao/l10n/app_localizations.dart';

class EmptyLesson extends StatelessWidget {
  const EmptyLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimalIllustration(
              asset: 'assets/animals/sloth.svg',
              size: 160,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.lessonNotFound,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.goBack),
            ),
          ],
        ),
      ),
    );
  }
}
