// ignore: unused_import
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:read_lao/enums/letter_type.dart';
import 'package:read_lao/exercises/learn_consonant_exercise.dart';
import 'package:read_lao/exercises/learn_vowel_exercise.dart';
import 'package:read_lao/exercises/learn_vowel_word_exercise.dart';
import 'package:read_lao/exercises/matching_exercise.dart';
import 'package:read_lao/exercises/select_letter_exercise.dart';
import 'package:read_lao/exercises/select_sound_exercise.dart';
import 'package:read_lao/exercises/stateful_exercise.dart';
import 'package:read_lao/typedefs/letter_type.dart';
import 'package:read_lao/utilities/letter_data.dart';

import '../exercises/spelling_exercise/spelling_exercise.dart';

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
    required Letter correctLetter,
    required List<Letter> allLetters,
  }) {
    final List<Letter> incorrectLetters =
        (List<Letter>.from(allLetters)..removeWhere(
              (letter) => letter.character == correctLetter.character,
            ))
            .shuffled()
            .take(2)
            .toList();
    return [
      SelectSoundExercise(
        correctLetter: correctLetter,
        incorrectLetters: incorrectLetters,
        key: UniqueKey(),
      ),
      SelectLetterExercise(
        correctLetter: correctLetter,
        incorrectLetters: incorrectLetters,
        key: UniqueKey(),
      ),
    ];
  }

  static List<Letter> _vowelWithPotentialVariation(Letter vowel) {
    return LetterData.vowelVariations.containsKey(vowel.character)
        ? [
            Letter(
              LetterData.vowelVariations[vowel.character]!,
              LetterType.vowel,
            ),
            vowel,
          ]
        : [vowel];
  }

  static List<StatefulExercise> generateLesson({
    required List<Letter> previouslyLearnedLetters,
    required List<Letter> newLetters,
    required List<Letter> currentlyLearningLetters,
    required LetterType lessonType,
  }) {
    final List<StatefulExercise> lessons = [];
    List<Letter> allLetters = lessonType == LetterType.consonant
        ? [...newLetters, ...currentlyLearningLetters]
        : [
            ...newLetters
                .map((vowel) => _vowelWithPotentialVariation(vowel))
                .expand((element) => element),
            ...currentlyLearningLetters
                .map((vowel) => _vowelWithPotentialVariation(vowel))
                .expand((element) => element),
          ];
    // Teach the new consonants and vowels
    // First teach the consonants one after another
    // But for the vowels with a variation
    // Teach both the variations at the same time,
    // then move onto the exercise pairs
    lessons.addAll(
      lessonType == LetterType.consonant
          ? [
              ...newLetters
                  .map(
                    (consonant) => <StatefulExercise>[
                      LearnConsonantExercise(consonant: consonant.character),
                      ..._generateExercisePair(
                        correctLetter: consonant,
                        allLetters: allLetters,
                      ),
                    ],
                  )
                  .expand((element) => element),
            ]
          : [
              ...newLetters
                  .map(
                    (vowel) => <StatefulExercise>[
                      ..._vowelWithPotentialVariation(vowel)
                          .map(
                            (vowel) => [
                              LearnVowelExercise(vowel: vowel.character),
                              LearnVowelWordExercise(vowel: vowel.character),
                            ],
                          )
                          .expand((element) => element),
                      ..._vowelWithPotentialVariation(vowel)
                          .map(
                            (vowel) => _generateExercisePair(
                              correctLetter: vowel,
                              allLetters: allLetters,
                            ),
                          )
                          .expand((element) => element),
                    ],
                  )
                  .expand((element) => element),
            ],
    );

    // Practice matching all currently

    late final List<List<Letter>> matchingSets;
    // If the complete list of letters to match is split-up-able into
    // equally sized chunkes of 5, split it up into chunks of 5
    if (allLetters.length % 5 == 0) {
      matchingSets = allLetters.slices(5).toList();
    } else {
      matchingSets = allLetters.slices(4).toList();
      // If the last set of matches has only a single pair in it
      // Move that pair to the second to last set of matches
      if (matchingSets.length > 1) {
        final lastIndex = matchingSets.length - 1;
        if (matchingSets[lastIndex].length == 1) {
          // Converts it to a growable list;
          matchingSets[lastIndex - 1] = matchingSets[lastIndex - 1].toList();
          matchingSets[lastIndex - 1].add(matchingSets[lastIndex][0]);
          matchingSets.removeAt(lastIndex);
        }
      }
    }

    for (List<Letter> matchingSet in matchingSets) {
      lessons.add(MatchingExercise(lettersToMatch: matchingSet));
    }

    // Main lesson content
    final List<StatefulExercise> shuffledExercises = [];

    for (Letter letter in allLetters) {
      shuffledExercises.addAll(
        _generateExercisePair(correctLetter: letter, allLetters: allLetters),
      );
    }
    Set<int> solidifiedLetters =
        (lessonType == LetterType.consonant
                ? [...currentlyLearningLetters, ...previouslyLearnedLetters]
                : [
                    ...currentlyLearningLetters
                        .map((vowel) => _vowelWithPotentialVariation(vowel))
                        .expand((element) => element),
                    ...previouslyLearnedLetters
                        .map((vowel) => _vowelWithPotentialVariation(vowel))
                        .expand((element) => element),
                  ])
            .map((letter) => letter.character.runes)
            .expand((runes) => runes)
            .toSet();

    if (lessonType == LetterType.vowel) {
      shuffledExercises.addAll(
        LetterData.spellingWords.keys
            .where(
              (word) =>
                  solidifiedLetters.containsAll(
                    LetterData.spellingWords[word]!,
                  ) ||
                  LetterData.spellingWords[word]!.isEmpty,
            )
            .shuffled()
            .take(3)
            .map((word) => SpellingExercise(word: word)),
      );
    }

    shuffledExercises.shuffle();
    lessons.addAll(shuffledExercises);

    for (List<Letter> matchingSet in matchingSets) {
      lessons.add(MatchingExercise(lettersToMatch: matchingSet));
    }

    return lessons;
  }

  static List<List<StatefulExercise>> generateLessonsForLetterType({
    required LetterType letterType,
  }) {
    final List<String> teachingOrder = letterType == LetterType.consonant
        ? LetterData.consonantTeachingOrder
        : LetterData.vowelTeachingOrder;

    final List<List<StatefulExercise>> lessons = [];

    // Because the vowels are taught after the consonants,
    // the consonants should already be in the list of previouslyLearnedLetters
    final List<Letter> previouslyLearnedLetters =
        letterType == LetterType.consonant
        ? []
        : LetterData.consonantTeachingOrder
              .map((consonant) => Letter(consonant, LetterType.consonant))
              .toList();
    final List<Letter> currentlyLearningLetters = [];

    int i = 0;
    while (i < teachingOrder.length) {
      // During the first lesson, include 2 new letters instead of 1
      final int lettersToAdd = (i == 0) ? 2 : 1;
      final int remainingLetters = teachingOrder.length - i;
      final int actualLettersToAdd = lettersToAdd.clamp(1, remainingLetters);

      final List<Letter> newLetters = List.generate(
        actualLettersToAdd,
        (index) => Letter(teachingOrder[i + index], letterType),
      );

      lessons.add(
        generateLesson(
          previouslyLearnedLetters: previouslyLearnedLetters,
          newLetters: newLetters,
          currentlyLearningLetters: currentlyLearningLetters,
          lessonType: letterType,
        ),
      );

      currentlyLearningLetters.addAll(newLetters);
      if (currentlyLearningLetters.length > 6) {
        previouslyLearnedLetters.add(currentlyLearningLetters.removeAt(0));
      }

      i += actualLettersToAdd;
    }
    return lessons;
  }

  static List<List<StatefulExercise>> generateLessons() {
    final List<List<StatefulExercise>> lessons = [];

    lessons.addAll(
      generateLessonsForLetterType(letterType: LetterType.consonant),
    );
    lessons.addAll(generateLessonsForLetterType(letterType: LetterType.vowel));

    return lessons;
  }
}
