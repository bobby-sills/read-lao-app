import 'package:flutter/material.dart';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/exercises/learn_consonant_exercise.dart';
import 'package:learn_lao_app/exercises/matching_exercise.dart';
import 'package:learn_lao_app/exercises/select_sound_exercise.dart';
import 'package:learn_lao_app/exercises/select_letter_exercise.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';
import 'package:collection/collection.dart';

class ConsonantLessonGenerator {
  static List<StatefulExercise> _generateExercisePair({
    required String correctLetter,
    required List<String> allLetters,
  }) {
    return [
      SelectSoundExercise(
        correctLetter: correctLetter,
        incorrectLetters: pickCountExcluding(
          allLetters,
          (allLetters.length - 1).clamp(0, 2),
          correctLetter,
        ),
        sectionType: SectionType.consonant,
        key: UniqueKey(),
      ),
      SelectLetterExercise(
        correctLetter: correctLetter,
        incorrectLetters: pickCountExcluding(
          allLetters,
          (allLetters.length - 1).clamp(0, 2),
          correctLetter,
        ),
        sectionType: SectionType.consonant,
        key: UniqueKey(),
      ),
    ];
  }

  static List<StatefulExercise> _generateLesson(List<String> letters) {
    final List<StatefulExercise> exercises = [];
    for (String correctLetter in letters) {
      exercises.addAll([
        LearnConsonantExercise(letter: correctLetter),
        ..._generateExercisePair(
          correctLetter: correctLetter,
          allLetters: letters,
        )..shuffle(),
      ]);
    }

    // If are there are more than 5 letters to match, split them up into two different sets of matching exercises
    final Iterable<List<String>> listOfMatches = (letters.length >= 6)
        ? letters.slices(3)
        : [letters];

    // Loop over each set of letters to matche
    for (List<String> matches in listOfMatches) {
      exercises.add(
        MatchingExercise(
          lettersToMatch: List.from(matches),
          sectionType: SectionType.consonant,
          key: UniqueKey(),
        ),
      );
    }

    final List<StatefulExercise> shuffledExercises = [];

    for (String correctLetter in letters) {
      shuffledExercises.addAll(
        _generateExercisePair(
          correctLetter: correctLetter,
          allLetters: letters,
        ),
      );
    }

    for (int i = 0; i < (letters.length / 3); i++) {
      shuffledExercises.add(
        MatchingExercise(
          lettersToMatch: pickCountExcluding(letters, 4),
          sectionType: SectionType.consonant,
          key: UniqueKey(),
        ),
      );
    }

    exercises.addAll(shuffledExercises);
    return exercises;
  }

  static List<List<StatefulExercise>> generateAllLessons(
    List<String> learningOrder,
  ) {
    final List<List<StatefulExercise>> lessons = [];
    final List<String> currentLetters = [];
    for (int i = 0; i < learningOrder.length; i += 2) {
      // Only remove 2 previously learned letters if there are enough to remove
      if (currentLetters.length >= 6) currentLetters.removeRange(0, 2);
      // Add 2 new letters that the user is going to learn
      final int endIndex = (i + 2).clamp(0, learningOrder.length);
      currentLetters.addAll(learningOrder.sublist(endIndex - 2, endIndex));
      print(learningOrder.sublist(endIndex - 2, endIndex));

      lessons.add(_generateLesson(currentLetters));
    }
    return lessons;
  }
}
