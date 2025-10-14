// ignore: unused_import
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:read_lao/enums/letter_type.dart';
import 'package:read_lao/exercises/spelling_exercise/spelling_exercise.dart';
import 'package:read_lao/typedefs/letter_type.dart';
import 'package:read_lao/utilities/letter_data.dart';
import 'package:read_lao/exercises/stateful_exercise.dart';
import 'package:read_lao/exercises/matching_exercise.dart';
import 'package:read_lao/exercises/learn_vowel_exercise.dart';
import 'package:read_lao/exercises/select_sound_exercise.dart';
import 'package:read_lao/exercises/select_letter_exercise.dart';
import 'package:read_lao/exercises/learn_consonant_exercise.dart';

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
              character: LetterData.vowelVariations[vowel.character]!,
              type: LetterType.vowel,
            ),
            vowel,
          ]
        : [vowel];
  }

  static List<StatefulExercise> generateLesson({
    required List<Letter> previouslyLearnedConsonants,
    required List<Letter> previouslyLearnedVowels,
    required List<Letter> newConsonants,
    required List<Letter> newVowels,
    required List<Letter> currentlyLearningConsonants,
    required List<Letter> currentlyLearningVowels,
  }) {
    final List<StatefulExercise> lesson = [];
    List<Letter> allLetters = [
      ...newConsonants,
      ...currentlyLearningConsonants,
      ...newVowels
          .map((vowel) => _vowelWithPotentialVariation(vowel))
          .expand((element) => element),
      ...currentlyLearningVowels
          .map((vowel) => _vowelWithPotentialVariation(vowel))
          .expand((element) => element),
    ];
    // Teach the new consonants and vowels
    // First teach the consonants one after another
    // But for the vowels with a variation
    // Teach both the variations at the same time,
    // then move onto the exercise pairs
    lesson.addAll([
      ...newConsonants
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
      ...newVowels
          .map(
            (vowel) => <StatefulExercise>[
              ..._vowelWithPotentialVariation(
                vowel,
              ).map((vowel) => LearnVowelExercise(vowel: vowel.character)),
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
    ]);

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
      lesson.add(MatchingExercise(lettersToMatch: matchingSet));
    }

    // Main lesson content
    final List<StatefulExercise> shuffledExercises = [];

    Set<int> solidifiedLetters = [
      ...currentlyLearningConsonants,
      ...previouslyLearnedConsonants,
      ...currentlyLearningVowels
          .map((vowel) => _vowelWithPotentialVariation(vowel))
          .expand((element) => element),
      ...previouslyLearnedVowels
          .map((vowel) => _vowelWithPotentialVariation(vowel))
          .expand((element) => element),
    ].map((letter) => letter.character.runes).expand((runes) => runes).toSet();
    final List<String> availableWords = [];

    for (String word in LetterData.spellingWords) {
      if (solidifiedLetters.containsAll(word.runes.toSet())) {
        availableWords.add(word);
      }
    }

    shuffledExercises.addAll(
      LetterData.spellingWords
          .where((word) => solidifiedLetters.containsAll(word.runes.toSet()))
          .shuffled()
          .take(3)
          .map((word) => SpellingExercise(word: word)),
    );

    for (Letter letter in allLetters) {
      shuffledExercises.addAll(
        _generateExercisePair(correctLetter: letter, allLetters: allLetters),
      );
    }

    shuffledExercises.shuffle();
    lesson.addAll(shuffledExercises);

    for (List<Letter> matchingSet in matchingSets) {
      lesson.add(MatchingExercise(lettersToMatch: matchingSet));
    }

    return lesson;
  }

  static void _generateLessonsForLetterType({
    required List<List<StatefulExercise>> lessons,
    required List<String> teachingOrder,
    required LetterType letterType,
    required List<Letter> previouslyLearnedConsonants,
    required List<Letter> currentlyLearningConsonants,
    required List<Letter> previouslyLearnedVowels,
    required List<Letter> currentlyLearningVowels,
  }) {
    int i = 0;
    while (i < teachingOrder.length) {
      // During the first lesson, include 2 new letters instead of 1
      final int lettersToAdd = (i == 0) ? 2 : 1;
      final int remainingLetters = teachingOrder.length - i;
      final int actualLettersToAdd = lettersToAdd.clamp(1, remainingLetters);

      final List<Letter> newLetters = List.generate(
        actualLettersToAdd,
        (index) => Letter(
          character: teachingOrder[i + index],
          type: letterType,
        ),
      );

      final bool isConsonant = letterType == LetterType.consonant;
      lessons.add(
        generateLesson(
          previouslyLearnedConsonants: previouslyLearnedConsonants,
          previouslyLearnedVowels: previouslyLearnedVowels,
          newConsonants: isConsonant ? newLetters : [],
          newVowels: isConsonant ? [] : newLetters,
          currentlyLearningConsonants: currentlyLearningConsonants,
          currentlyLearningVowels: currentlyLearningVowels,
        ),
      );

      final List<Letter> currentlyLearning =
          isConsonant ? currentlyLearningConsonants : currentlyLearningVowels;
      final List<Letter> previouslyLearned =
          isConsonant ? previouslyLearnedConsonants : previouslyLearnedVowels;

      currentlyLearning.addAll(newLetters);
      if (currentlyLearning.length > 6) {
        previouslyLearned.add(currentlyLearning.removeAt(0));
      }

      i += actualLettersToAdd;
    }
  }

  static List<List<StatefulExercise>> generateLessons() {
    final List<List<StatefulExercise>> lessons = [];

    final List<Letter> previouslyLearnedConsonants = [];
    final List<Letter> currentlyLearningConsonants = [];
    _generateLessonsForLetterType(
      lessons: lessons,
      teachingOrder: LetterData.consonantTeachingOrder,
      letterType: LetterType.consonant,
      previouslyLearnedConsonants: previouslyLearnedConsonants,
      currentlyLearningConsonants: currentlyLearningConsonants,
      previouslyLearnedVowels: [],
      currentlyLearningVowels: [],
    );

    final List<Letter> previouslyLearnedVowels = [];
    final List<Letter> currentlyLearningVowels = [];
    _generateLessonsForLetterType(
      lessons: lessons,
      teachingOrder: LetterData.vowelTeachingOrder,
      letterType: LetterType.vowel,
      previouslyLearnedConsonants: [],
      currentlyLearningConsonants: [],
      previouslyLearnedVowels: previouslyLearnedVowels,
      currentlyLearningVowels: currentlyLearningVowels,
    );

    return lessons;
  }
}
