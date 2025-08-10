import 'dart:math';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/exercises/learn_consonant_exercise.dart';
import 'package:learn_lao_app/exercises/matching_exercise.dart';
import 'package:learn_lao_app/exercises/select_sound_exercise.dart';
import 'package:learn_lao_app/exercises/select_letter_exercise.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';
import 'package:learn_lao_app/utilities/letter_data.dart';
import 'package:collection/collection.dart';

class ConsonantLessonGenerator {
  List<StatefulExercise> generateLesson(List<String> letters) {
    final List<StatefulExercise> lessons = [];
    for (String letter in letters) {
      lessons.addAll([
        LearnConsonantExercise(letter: letter),
        ...[
          SelectSoundExercise(
            correctLetter: letter,
            incorrectLetters: pickCountExcluding(
              letters,
              (letters.length - 1).clamp(0, 2),
              letter,
            ),
            sectionType: SectionType.consonant,
          ),
          SelectLetterExercise(
            correctLetter: letter,
            incorrectLetters: pickCountExcluding(
              letters,
              (letters.length - 1).clamp(0, 2),
              letter,
            ),
            sectionType: SectionType.consonant,
          ),
        ]..shuffle(),
      ]);
    }

    // If are there are more than 5 letters to match, split them up into two different sets of matching exercises
    final Iterable<List<String>> listOfMatches = (letters.length > 5)
        ? letters.slices(3)
        : [letters];

    // Loop over each set of letters to matche
    for (List<String> matches in listOfMatches) {
      lessons.add(
        MatchingExercise(
          lettersToMatch: matches,
          sectionType: SectionType.consonant,
        ),
      );
    }


    final List<StatefulExercise> shuffledExercises = [];

    for (String letter in letters) {
      shuffledExercises.addAll([
          SelectSoundExercise(
            correctLetter: letter,
            incorrectLetters: pickCountExcluding(
              letters,
              (letters.length - 1).clamp(0, 2),
              letter,
            ),
            sectionType: SectionType.consonant,
          ),
          SelectLetterExercise(
            correctLetter: letter,
            incorrectLetters: pickCountExcluding(
              letters,
              (letters.length - 1).clamp(0, 2),
              letter,
            ),
            sectionType: SectionType.consonant,
          )]);
      }
    lessons.addAll(
    [
    ...letters.map((letter)=> ...[SelectSoundExercise(
            correctLetter: letter,
            incorrectLetters: pickCountExcluding(
              letters,
              (letters.length - 1).clamp(0, 2),
              letter,
            ),
            sectionType: SectionType.consonant,
          ),
          SelectLetterExercise(
            correctLetter: letter,
            incorrectLetters: pickCountExcluding(
              letters,
              (letters.length - 1).clamp(0, 2),
              letter,
            ),
            sectionType: SectionType.consonant,
          )]))

      for (String letter in letters)
          ...    ]..shuffle());

    return lessons;
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
        LearnConsonantExercise(
          letter: letter,
          word: LetterData.lettersToWords[letter]!,
        ),
        SelectLetterExercise(
          correctLetter: letter,
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
        ),
        SelectSoundExercise(
          correctLetter: letter,
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
        ),
      ]);
    }

    // 2. Simple matching with all three letters
    generatedLessons[0].add(
      MatchingExercise(
        lettersToMatch: firstThreeLetters,
        sectionType: SectionType.consonant,
      ),
    );

    // 3. Mixed practice (no duplicates needed)
    List<String> shuffledLetters = [...firstThreeLetters];
    shuffledLetters.shuffle();

    for (var letter in shuffledLetters) {
      generatedLessons[0].addAll([
        SelectSoundExercise(
          correctLetter: letter,
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
        ),
        SelectLetterExercise(
          correctLetter: letter,
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
        ),
      ]);
    }

    // 4. Final assessment - single matching with all three
    generatedLessons[0].add(
      MatchingExercise(
        lettersToMatch: firstThreeLetters,
        sectionType: SectionType.consonant,
      ),
    );

    // LESSON 2: Reinforcement
    // ======================

    // 1. Quick review
    for (var letter in firstThreeLetters) {
      generatedLessons[1].add(
        SelectLetterExercise(
          correctLetter: letter,
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
        ),
      );
    }

    // 2. Matching practice
    generatedLessons[1].add(
      MatchingExercise(
        lettersToMatch: firstThreeLetters,
        sectionType: SectionType.consonant,
      ),
    );

    // 3. Sound practice
    for (var letter in firstThreeLetters) {
      generatedLessons[1].add(
        SelectSoundExercise(
          correctLetter: letter,
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
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
                incorrectLetters: pickCountExcluding(
                  firstThreeLetters,
                  2,
                  letter,
                ),
                sectionType: SectionType.consonant,
              )
            : SelectSoundExercise(
                correctLetter: letter,
                incorrectLetters: pickCountExcluding(
                  firstThreeLetters,
                  2,
                  letter,
                ),
                sectionType: SectionType.consonant,
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
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
        ),
        SelectLetterExercise(
          correctLetter: letter,
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
        ),
      ]);
    }

    // 2. Comprehensive matching
    generatedLessons[2].add(
      MatchingExercise(
        lettersToMatch: firstThreeLetters,
        sectionType: SectionType.consonant,
      ),
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
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
        ),
      );
    }

    for (var letter in speedRound2) {
      generatedLessons[2].add(
        SelectSoundExercise(
          correctLetter: letter,
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
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
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
        ),
        SelectSoundExercise(
          correctLetter: letter,
          incorrectLetters: pickCountExcluding(firstThreeLetters, 2, letter),
          sectionType: SectionType.consonant,
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
    List<String> incorrectLetters,
  ) {
    List<List<StatefulExercise>> allLessons = [];

    // Ensure we have at least 3 letters to work with
    if (incorrectLetters.length < 3) {
      throw ArgumentError('Need at least 3 letters to generate lessons');
    }

    // First cycle: Use special first lesson logic to avoid duplicate letter issues
    List<String> firstThree = incorrectLetters.take(3).toList();
    List<List<StatefulExercise>> firstCycle = generateFirstLessonCycle(
      firstThree,
    );
    allLessons.addAll(firstCycle);

    // Subsequent cycles: 3 new letters + 3 from previous cycle
    for (int i = 3; i < incorrectLetters.length; i += 3) {
      List<String> newLetters = [];
      List<String> oldLetters = incorrectLetters.sublist(
        i - 3,
        i,
      ); // Previous 3 letters

      // Get the next 3 letters (or remaining letters if less than 3)
      int endIndex = (i + 3 <= incorrectLetters.length)
          ? i + 3
          : incorrectLetters.length;
      newLetters = incorrectLetters.sublist(i, endIndex);

      // If we have fewer than 3 new letters, pad with recent letters for practice
      while (newLetters.length < 3 && incorrectLetters.length >= 3) {
        // Add letters from earlier in the curriculum for review
        int paddingIndex =
            (i - 6 + newLetters.length) % incorrectLetters.length;
        if (paddingIndex < 0) paddingIndex = newLetters.length;

        String paddingLetter = incorrectLetters[paddingIndex];
        if (!newLetters.contains(paddingLetter) &&
            !oldLetters.contains(paddingLetter)) {
          newLetters.add(paddingLetter);
        } else {
          // If we can't find a unique letter, just repeat from the start
          newLetters.add(
            incorrectLetters[newLetters.length % incorrectLetters.length],
          );
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
