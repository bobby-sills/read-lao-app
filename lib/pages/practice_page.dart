import 'package:flutter/material.dart';
import 'dart:math';
import 'package:read_lao/components/animal_illustration.dart';
import 'package:read_lao/l10n/app_localizations.dart';
import 'package:read_lao/utilities/letter_data.dart';
import 'package:read_lao/exercises/spelling_exercise/spelling_exercise.dart';
import 'package:read_lao/pages/lesson_wrapper.dart';

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  List<Widget> _generateRandomSpellingExercises(int count) {
    final random = Random();
    final words = LetterData.vowelWords.values.toList();
    final List<Widget> addedExercises = [];
    final Set<String> addedWords = {};
    String randomWord;

    for (int i = 0; i < count; i++) {
      do {
        randomWord = words[random.nextInt(words.length)];
      } while (addedWords.contains(randomWord));
      addedWords.add(randomWord);
      addedExercises.add(SpellingExercise(word: randomWord));
    }

    return addedExercises.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AnimalIllustration(
                asset: 'assets/animals/chicken.svg',
                size: 140,
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.practiceSpellingTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.practiceSpellingDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  final exercises = _generateRandomSpellingExercises(10);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LessonWrapper(exercises: exercises, lessonIndex: -1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.startPractice),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
