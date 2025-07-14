import 'dart:math';
import 'package:learn_lao_app/exercises/learn_consonant_exercise.dart';
import 'package:learn_lao_app/exercises/matching_exercise.dart';
import 'package:learn_lao_app/exercises/select_sound_exercise.dart';
import 'package:learn_lao_app/exercises/select_letter_exercise.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';

class LessonGenerator {
  // Complete 3-lesson cycle generator for Lao consonant learning
  // Input: newLetters (3 new consonants), oldLetters (3 previously learned)

  List<List<StatefulExercise>> generateLessonCycle(
    List<String> newLetters,
    List<String> oldLetters,
  ) {
    List<List<StatefulExercise>> generatedLessons = [[], [], []];

    // LESSON 1: Introduction & Initial Practice
    // ========================================

    // 1. New Letter Introduction
    for (var letter in newLetters) {
      generatedLessons[0].addAll([
        LearnConsonantExercise(letter: letter, word: lettersToWords[letter]!),
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(newLetters, 3, letter),
        ),
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(newLetters, 3, letter),
        ),
      ]);
    }

    // 2. Old Letter Review
    generatedLessons[0].add(MatchingExercise(lettersToMatch: oldLetters));

    // 3. Mixed Practice (randomized)
    List<String> combinedLetters = <String>{
      ...oldLetters,
      ...newLetters,
    }.toList();
    combinedLetters.shuffle();

    final shuffledExercises = <StatefulExercise>[];
    for (var letter in combinedLetters) {
      shuffledExercises.addAll([
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(combinedLetters, 3, letter),
        ),
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(combinedLetters, 3, letter),
        ),
      ]);
    }
    shuffledExercises.shuffle();
    generatedLessons[0].addAll(shuffledExercises);

    // 4. Final Assessment - Split into groups of max 5 letters
    List<String> finalShuffled = [...combinedLetters];
    finalShuffled.shuffle();
    generatedLessons[0].addAll([
      MatchingExercise(lettersToMatch: finalShuffled.sublist(0, 3)),
      MatchingExercise(lettersToMatch: finalShuffled.sublist(3, 6)),
    ]);

    // LESSON 2: Reinforcement & Integration
    // ====================================

    // 1. Quick Review (new letters only)
    for (var letter in newLetters) {
      generatedLessons[1].add(
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(newLetters, 3, letter),
        ),
      );
    }

    // 2. Focused New Letter Practice
    generatedLessons[1].add(MatchingExercise(lettersToMatch: newLetters));

    for (var letter in newLetters) {
      generatedLessons[1].add(
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(
            combinedLetters,
            4,
            letter,
          ), // Harder: 4 options
        ),
      );
    }

    // 3. Integration Challenges
    List<String> randomSubset1 = getRandomSubset(combinedLetters, 4);
    List<String> randomSubset2 = getRandomSubset(combinedLetters, 4);

    for (var letter in randomSubset1) {
      generatedLessons[1].add(
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(combinedLetters, 4, letter),
        ),
      );
    }

    for (var letter in randomSubset2) {
      generatedLessons[1].add(
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(combinedLetters, 4, letter),
        ),
      );
    }

    // 4. Comprehensive Review
    // Split combined letters into groups of max 5 for matching
    List<String> shuffledCombined = [...combinedLetters];
    shuffledCombined.shuffle();
    generatedLessons[1].add(
      MatchingExercise(lettersToMatch: shuffledCombined.take(5).toList()),
    );
    List<String> finalMixed = [...combinedLetters];
    finalMixed.shuffle();
    for (var letter in finalMixed) {
      generatedLessons[1].add(
        Random().nextBool()
            ? SelectLetterExercise(
                correctLetter: letter,
                allLetters: getExerciseOptions(combinedLetters, 3, letter),
              )
            : SelectSoundExercise(
                correctLetter: letter,
                allLetters: getExerciseOptions(combinedLetters, 3, letter),
              ),
      );
    }

    // LESSON 3: Mastery & Preparation
    // ===============================

    // 1. Mastery Check (new letters)
    for (var letter in newLetters) {
      generatedLessons[2].addAll([
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(
            combinedLetters,
            4,
            letter,
          ), // Max difficulty
        ),
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(combinedLetters, 4, letter),
        ),
      ]);
    }

    // 2. Speed Challenges
    List<String> speedRound1 = getRandomSubset(combinedLetters, 6);
    List<String> speedRound2 = getRandomSubset(combinedLetters, 6);

    for (var letter in speedRound1) {
      generatedLessons[2].add(
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(combinedLetters, 4, letter),
        ),
      );
    }

    for (var letter in speedRound2) {
      generatedLessons[2].add(
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(combinedLetters, 4, letter),
        ),
      );
    }

    // 3. Complex Matching - Split combined letters into groups of max 5
    List<String> matchingShuffled = [...combinedLetters];
    matchingShuffled.shuffle();
    generatedLessons[2].add(
      MatchingExercise(lettersToMatch: matchingShuffled.take(5).toList()),
    );

    // Split matching with mixed old/new
    List<String> splitGroup1 = [oldLetters[0], oldLetters[1], newLetters[0]];
    List<String> splitGroup2 = [oldLetters[2], newLetters[1], newLetters[2]];

    generatedLessons[2].addAll([
      MatchingExercise(lettersToMatch: splitGroup1),
      MatchingExercise(lettersToMatch: splitGroup2),
    ]);

    // 4. Final Assessment
    List<String> comprehensiveMixed = [...combinedLetters];
    comprehensiveMixed.shuffle();

    for (var letter in comprehensiveMixed) {
      // Random exercise type for variety
      var exerciseTypes = [
        () => SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(combinedLetters, 4, letter),
        ),
        () => SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(combinedLetters, 4, letter),
        ),
      ];
      generatedLessons[2].add(exerciseTypes[Random().nextInt(2)]());
    }

    // Graduation check: rapid-fire new letters
    for (var letter in newLetters) {
      generatedLessons[2].addAll([
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(combinedLetters, 4, letter),
        ),
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(combinedLetters, 4, letter),
        ),
      ]);
    }

    return generatedLessons;
  }

  // Helper function to get a random subset of specified size
  List<String> getRandomSubset(List<String> source, int size) {
    List<String> shuffled = [...source];
    shuffled.shuffle();
    return shuffled.take(size).toList();
  }

  // SPECIAL FIRST LESSON CYCLE GENERATOR
  // ===================================

  /// Generates a special 3-lesson cycle for the very first letters
  /// This avoids the duplicate letter issue by not mixing old/new letters
  List<List<StatefulExercise>> generateFirstLessonCycle(
    List<String> firstThreeLetters,
  ) {
    List<List<StatefulExercise>> generatedLessons = [[], [], []];

    // LESSON 1: Pure Introduction (no old letters to mix)
    // =================================================

    // 1. Individual letter introduction
    for (var letter in firstThreeLetters) {
      generatedLessons[0].addAll([
        LearnConsonantExercise(letter: letter, word: lettersToWords[letter]!),
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
      ]);
    }

    // 2. Simple matching with all three letters
    generatedLessons[0].add(
      MatchingExercise(lettersToMatch: firstThreeLetters),
    );

    // 3. Mixed practice (no duplicates needed)
    List<String> shuffledLetters = [...firstThreeLetters];
    shuffledLetters.shuffle();

    for (var letter in shuffledLetters) {
      generatedLessons[0].addAll([
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
      ]);
    }

    // 4. Final assessment - single matching with all three
    generatedLessons[0].add(
      MatchingExercise(lettersToMatch: firstThreeLetters),
    );

    // LESSON 2: Reinforcement
    // ======================

    // 1. Quick review
    for (var letter in firstThreeLetters) {
      generatedLessons[1].add(
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
      );
    }

    // 2. Matching practice
    generatedLessons[1].add(
      MatchingExercise(lettersToMatch: firstThreeLetters),
    );

    // 3. Sound practice
    for (var letter in firstThreeLetters) {
      generatedLessons[1].add(
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
      );
    }

    // 4. Mixed exercises
    List<String> mixedOrder = [...firstThreeLetters];
    mixedOrder.shuffle();
    for (var letter in mixedOrder) {
      generatedLessons[1].add(
        Random().nextBool()
            ? SelectLetterExercise(
                correctLetter: letter,
                allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
              )
            : SelectSoundExercise(
                correctLetter: letter,
                allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
              ),
      );
    }

    // LESSON 3: Mastery
    // ================

    // 1. Mastery check
    for (var letter in firstThreeLetters) {
      generatedLessons[2].addAll([
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
      ]);
    }

    // 2. Comprehensive matching
    generatedLessons[2].add(
      MatchingExercise(lettersToMatch: firstThreeLetters),
    );

    // 3. Speed rounds
    List<String> speedRound1 = [...firstThreeLetters];
    List<String> speedRound2 = [...firstThreeLetters];
    speedRound1.shuffle();
    speedRound2.shuffle();

    for (var letter in speedRound1) {
      generatedLessons[2].add(
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
      );
    }

    for (var letter in speedRound2) {
      generatedLessons[2].add(
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
      );
    }

    // 4. Final graduation check
    List<String> finalOrder = [...firstThreeLetters];
    finalOrder.shuffle();
    for (var letter in finalOrder) {
      generatedLessons[2].addAll([
        SelectLetterExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
        SelectSoundExercise(
          correctLetter: letter,
          allLetters: getExerciseOptions(firstThreeLetters, 3, letter),
        ),
      ]);
    }

    return generatedLessons;
  }

  // MAIN CURRICULUM GENERATOR
  // =========================

  /// Generates the complete curriculum for all letters as a flat list
  /// Returns a single list of all lessons in order
  List<List<StatefulExercise>> generateCompleteCurriculum(
    List<String> allLetters,
  ) {
    List<List<StatefulExercise>> allLessons = [];

    // Ensure we have at least 3 letters to work with
    if (allLetters.length < 3) {
      throw ArgumentError('Need at least 3 letters to generate lessons');
    }

    // First cycle: Use special first lesson logic to avoid duplicate letter issues
    List<String> firstThree = allLetters.take(3).toList();
    List<List<StatefulExercise>> firstCycle = generateFirstLessonCycle(
      firstThree,
    );
    allLessons.addAll(firstCycle);

    // Subsequent cycles: 3 new letters + 3 from previous cycle
    for (int i = 3; i < allLetters.length; i += 3) {
      List<String> newLetters = [];
      List<String> oldLetters = allLetters.sublist(
        i - 3,
        i,
      ); // Previous 3 letters

      // Get the next 3 letters (or remaining letters if less than 3)
      int endIndex = (i + 3 <= allLetters.length) ? i + 3 : allLetters.length;
      newLetters = allLetters.sublist(i, endIndex);

      // If we have fewer than 3 new letters, pad with recent letters for practice
      while (newLetters.length < 3 && allLetters.length >= 3) {
        // Add letters from earlier in the curriculum for review
        int paddingIndex = (i - 6 + newLetters.length) % allLetters.length;
        if (paddingIndex < 0) paddingIndex = newLetters.length;

        String paddingLetter = allLetters[paddingIndex];
        if (!newLetters.contains(paddingLetter) &&
            !oldLetters.contains(paddingLetter)) {
          newLetters.add(paddingLetter);
        } else {
          // If we can't find a unique letter, just repeat from the start
          newLetters.add(allLetters[newLetters.length % allLetters.length]);
        }
      }

      List<List<StatefulExercise>> cycle = generateLessonCycle(
        newLetters,
        oldLetters,
      );
      allLessons.addAll(cycle);
    }

    return allLessons;
  }

  /// Helper function to determine which letters are the focus of a given cycle

  // Usage examples:
  //
  // // Generate complete curriculum for all Lao consonants as a flat list
  // List<String> laoConsonants = [
  //   'ກ', 'ຂ', 'ຄ', 'ງ', 'ຈ', 'ສ', 'ຊ', 'ຍ', 'ດ', 'ຕ',
  //   'ຖ', 'ທ', 'ນ', 'ບ', 'ປ', 'ຜ', 'ຝ', 'ພ', 'ຟ', 'ມ',
  //   'ຢ', 'ຣ', 'ລ', 'ວ', 'ຫ', 'ອ', 'ຮ'
  // ];
  //
  // // Option 1: Get simple flat list of lessons
  // List<List<StatefulExercise>> allLessons = generateCompleteCurriculum(laoConsonants);
  // // allLessons[0] = first lesson of first cycle
  // // allLessons[1] = second lesson of first cycle
  // // allLessons[2] = third lesson of first cycle
  // // allLessons[3] = first lesson of second cycle
  // // etc...
  //
  // // Option 2: Get flat list with metadata
  // List<LessonWithMetadata> lessonsWithInfo = generateCurriculumWithMetadata(laoConsonants);
  // // lessonsWithInfo[0].title = "Cycle 1 - Lesson 1"
  // // lessonsWithInfo[0].description = "Introduction to letters: ກ, ຂ, ຄ"
  // // lessonsWithInfo[3].title = "Cycle 2 - Lesson 1"
}
