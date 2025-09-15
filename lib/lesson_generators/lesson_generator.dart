import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:learn_lao_app/enums/letter_type.dart';
import 'package:learn_lao_app/typedefs/letter_type.dart';
import 'package:learn_lao_app/utilities/letter_data.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/exercises/matching_exercise.dart';
import 'package:learn_lao_app/exercises/learn_vowel_exercise.dart';
import 'package:learn_lao_app/exercises/select_sound_exercise.dart';
import 'package:learn_lao_app/exercises/select_letter_exercise.dart';
import 'package:learn_lao_app/exercises/learn_consonant_exercise.dart';

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
    required Letter letter,
    required List<Letter> allLetters,
  }) {
    final List<Letter> incorrectLetters = pickCountExcluding(
      list: allLetters,
      count: (allLetters.length - 1).clamp(0, 2),
      correct: letter,
    );
    return [
      SelectSoundExercise(
        correctLetter: letter,
        incorrectLetters: incorrectLetters,
        key: UniqueKey(),
      ),
      SelectLetterExercise(
        correctLetter: letter,
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

  static List<StatefulExercise> generateLesson(
    List<Letter> previouslyLearnedConsonants,
    List<Letter> previouslyLearnedVowels,
    List<Letter> newConsonants,
    List<Letter> newVowels,
    List<Letter> currentlyLearningConsonants,
    List<Letter> currentlyLearningVowels,
  ) {
    final List<StatefulExercise> lesson = [];
    List<Letter> allLetters = [
      ...newConsonants,
      ...newVowels
          .map((vowel) => _vowelWithPotentialVariation(vowel))
          .expand((element) => element),
      ...currentlyLearningConsonants,
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
                letter: consonant,
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
                      letter: vowel,
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
      final lastIndex = matchingSets.length - 1;
      if (matchingSets[lastIndex].length == 1) {
        // Converts it to a growable list;
        matchingSets[lastIndex - 1] = matchingSets[lastIndex - 1].toList();
        matchingSets[lastIndex - 1].add(matchingSets[lastIndex][0]);
        matchingSets.removeAt(lastIndex);
      }
    }

    for (List<Letter> matchingSet in matchingSets) {
      lesson.add(MatchingExercise(lettersToMatch: matchingSet));
    }

    final List<StatefulExercise> shuffledExercises = [];

    for (Letter letter in allLetters) {
      shuffledExercises.addAll(
        _generateExercisePair(letter: letter, allLetters: allLetters),
      );
    }

    shuffledExercises.shuffle();
    lesson.addAll(shuffledExercises);

    for (List<Letter> matchingSet in matchingSets) {
      lesson.add(MatchingExercise(lettersToMatch: matchingSet));
    }
    return lesson;
  }

  static List<List<StatefulExercise>> generateLessons() {
    final List<List<StatefulExercise>> lessons = [];

    final List<Letter> previouslyLearnedConsonants = [];
    final List<Letter> previouslyLearnedVowels = [];
    final List<Letter> currentlyLearningConsonants = [];
    final List<Letter> currentlyLearningVowels = [];
    for (final pair in IterableZip([
      LetterData.consonantOrder,
      LetterData.vowelTeachingOrder,
    ])) {
      final (newConsonant, newVowel) = (
        Letter(character: pair[0], type: LetterType.consonant),
        Letter(character: pair[1], type: LetterType.vowel),
      );
      lessons.add(
        generateLesson(
          previouslyLearnedConsonants,
          previouslyLearnedVowels,
          [newConsonant], // new consonant
          [newVowel], // new vowel
          currentlyLearningConsonants,
          currentlyLearningVowels,
        ),
      );
      inspect(
        generateLesson(
          previouslyLearnedConsonants,
          previouslyLearnedVowels,
          [newConsonant], // new consonant
          [newVowel], // new vowel
          currentlyLearningConsonants,
          currentlyLearningVowels,
        ),
      );
      currentlyLearningConsonants.add(newConsonant);
      currentlyLearningVowels.add(newVowel);
      // If the total length of the letters currently being leraned is more than
      // 6
      if (currentlyLearningConsonants.length + currentlyLearningVowels.length >
          6) {
        // If the consonants list has more than the vowels list
        // delete one from the consonants list, and vice versa
        if (currentlyLearningConsonants.length ==
            currentlyLearningVowels.length) {
          previouslyLearnedConsonants.add(
            currentlyLearningConsonants.removeLast(),
          );
          previouslyLearnedVowels.add(currentlyLearningVowels.removeLast());
        } else if (currentlyLearningConsonants.length >
            currentlyLearningVowels.length) {
          previouslyLearnedConsonants.add(
            currentlyLearningConsonants.removeLast(),
          );
        } else if (currentlyLearningVowels.length >
            currentlyLearningConsonants.length) {
          previouslyLearnedVowels.add(currentlyLearningVowels.removeLast());
        }
      }
    }
    return lessons;
  }
}
