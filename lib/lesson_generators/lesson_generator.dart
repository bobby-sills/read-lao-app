import 'package:flutter/material.dart';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/exercises/learn_consonant_exercise.dart';
import 'package:learn_lao_app/exercises/learn_vowel_exercise.dart';
import 'package:learn_lao_app/exercises/matching_exercise.dart';
import 'package:learn_lao_app/exercises/select_sound_exercise.dart';
import 'package:learn_lao_app/exercises/select_letter_exercise.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/typedefs/matching_data.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';
import 'package:collection/collection.dart';

class LessonGenerator {
  /*
   *  ~ lesson generator function plan ~
   *
   *  learn new letters and practice them with lesson pair - done
   *  match all letters currently learning - done
   *  start batch of shuffled exercises containing:
   *    lesson pair of each letter
   *    guess nonsense words from new letters
   *    practice spelling (<=3) words with (any) letters learned in previous lessons
   *  match all letters currently learning
  */

  static List<StatefulExercise> _generateExercisePair({
    required String correctLetter,
    required List<String> allLetters,
    required SectionType sectionType,
  }) {
    return [
      SelectSoundExercise(
        correctLetter: correctLetter,
        incorrectLetters: pickCountExcluding(
          allLetters,
          (allLetters.length - 1).clamp(0, 2),
          correctLetter,
        ),
        sectionType: sectionType,
        key: UniqueKey(),
      ),
      SelectLetterExercise(
        correctLetter: correctLetter,
        incorrectLetters: pickCountExcluding(
          allLetters,
          (allLetters.length - 1).clamp(0, 2),
          correctLetter,
        ),
        sectionType: sectionType,
        key: UniqueKey(),
      ),
    ];
  }

  static List<StatefulExercise> generateLesson(
    List<String> previouslyLearnedConsonants,
    List<String> previouslyLearnedVowels,
    List<String> newConsonants,
    List<String> newVowels,
    List<String> currentlyLearningConsonants,
    List<String> currentlyLearningVowels,
  ) {
    final List<StatefulExercise> lesson = [];
    lesson.addAll([
      ...newConsonants.map(
        (consonant) => LearnConsonantExercise(consonant: consonant),
      ),
      ...newVowels.map((vowel) => LearnVowelExercise(vowel: vowel)),
    ]);
    List<MatchingData> lettersToMatch = [
      ...newConsonants.map((consonant) => {consonant: SectionType.consonant}),
      ...newVowels.map((vowel) => {vowel: SectionType.vowel}),
      ...currentlyLearningConsonants.map(
        (consonant) => {consonant: SectionType.consonant},
      ),
      ...currentlyLearningVowels.map((vowel) => {vowel: SectionType.vowel}),
    ];

    late final List<List<MatchingData>> matchingSets;
    // If the complete list of letters to match is split-up-able into
    // equally sized chunkes of 5, split it up into chunks of 5
    if (lettersToMatch.length % 5 == 0) {
      matchingSets = lettersToMatch.slices(5).toList();
    } else {
      matchingSets = lettersToMatch.slices(4).toList();
      // If the last set of matches has only a single pair in it
      // Move that pair to the second to last set of matches
      final lastIndex = matchingSets.length - 1;
      if (matchingSets[lastIndex].length == 1) {
        matchingSets[lastIndex - 1].add(matchingSets[lastIndex][0]);
        matchingSets.removeAt(lastIndex);
      }
    }

    for (List<MatchingData> matchingSet in matchingSets) {
      final MatchingData matchingData = {
        for (MatchingData data in matchingSet) ...data,
      };
      lesson.add(MatchingExercise(lettersToMatch: matchingData));
    }

    return [];
  }

  static List<StatefulExercise> _generateLesson(List<String> letters) {
    final List<StatefulExercise> exercises = [];
    for (String correctLetter in letters) {
      exercises.addAll([
        LearnConsonantExercise(consonant: correctLetter),
        ..._generateExercisePair(
          correctLetter: correctLetter,
          allLetters: letters,
          sectionType: SectionType.consonant,
        )..shuffle(),
      ]);
    }

    // If are there are more than 5 letters to match, split them up into two different sets of matching exercises
    final Iterable<List<String>> listOfMatches = (letters.length >= 6)
        ? letters.slices(3)
        : [letters];

    // Loop over each set of letters to match
    for (List<String> matches in listOfMatches) {
      exercises.add(
        MatchingExercise(
          lettersToMatch: {
            for (String item in List.from(matches)) item: SectionType.consonant,
          },
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
          sectionType: SectionType.consonant,
        ),
      );
    }

    for (int i = 0; i < (letters.length / 3); i++) {
      shuffledExercises.add(
        MatchingExercise(
          lettersToMatch: {
            for (String item in pickCountExcluding(letters, 4))
              item: SectionType.consonant,
          },
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
