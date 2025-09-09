import 'dart:math';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/exercises/learn_vowel_exercise.dart';
import 'package:learn_lao_app/exercises/matching_exercise.dart';
import 'package:learn_lao_app/exercises/select_letter_exercise.dart';
import 'package:learn_lao_app/exercises/select_sound_exercise.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';
import 'package:learn_lao_app/utilities/letter_data.dart';

class VowelLessonGenerator {
  static List<List<StatefulExercise>> generateAllLessons(
    List<String> learningOrder,
  ) {
    final List<List<StatefulExercise>> lessons = [];
    // generate first pair with only two
    lessons.addAll(_generateLessonPair([learningOrder[0], learningOrder[1]]));

    // generate the rest
    // `i` is set to two because the first two were already generated
    for (var i = 2; i < learningOrder.length; i++) {
      final List<String> vowelPair = learningOrder.sublist(
        i,
        (i + 2).clamp(0, learningOrder.length),
      );
      lessons.addAll(_generateLessonPair(vowelPair));
    }

    return lessons;
  }

  /// Generates a complete lesson sequence from a list of vowels
  ///
  /// Takes a list of vowel strings and creates a comprehensive lesson that includes:
  /// - Introduction exercises for each vowel and its variations
  /// - Letter recognition exercises (select the correct letter)
  /// - Sound recognition exercises (select the correct sound)
  ///
  /// [vowels] List of vowel strings to create exercises for
  /// Returns a list of StatefulExercise objects in the proper learning sequence
  static List<List<StatefulExercise>> _generateLessonPair(List<String> vowels) {
    assert(
      vowels.length <= 2,
      'The input must be a _pair_ of vowels, no more than 2',
    );

    final Random random = Random();

    final List<List<StatefulExercise>> lessons = [[], []];

    // Create a list of vowel variations for each input vowel
    // Some vowels have alternative writing forms, others have just one form
    final List<List<String>> variations = vowels
        .map(
          (vowel) => (LetterData.vowelVariations[vowel] == null)
              ? [vowel] // Single form vowel
              : [
                  vowel,
                  LetterData.vowelVariations[vowel]!,
                ], // Multiple form vowel
        )
        .toList();
    // Process each vowel and its variations
    for (List<String> vowel in variations) {
      // Step 1: Introduction phase - teach each vowel variation
      // Creates LearnVowelExercise for each form of the vowel
      for (String variation in vowel) {
        lessons[0].add(LearnVowelExercise(vowel: variation));
      }

      // Step 2: Practice phase - randomized exercise selection
      // Randomly choose between letter selection and sound selection exercises
      bool isLetterMatchingExercise = random.nextBool();
      bool usingDefaultPlaceholder = false;
      // Create one round for the exercises without placeholders and another one for
      // the ones with them
      for (int i = 0; i < 2; i++) {
        // Create two rounds of practice exercises for each vowel variation
        for (int i = 0; i < 2; i++) {
          for (String variation in vowel) {
            // Select exercise type based on random boolean
            final selectExercise = isLetterMatchingExercise
                ? SelectLetterExercise.new
                : SelectSoundExercise.new;

            final String correctLetter;
            final List<String> incorrectLetters;
            if (usingDefaultPlaceholder) {
              correctLetter = variation;
              incorrectLetters = pickCountExcluding(vowels, 2, variation);
            } else {
              correctLetter = addConsonantToVowel(
                LetterData.randomPlaceholder(random),
                variation,
              );
              incorrectLetters = pickCountExcluding(vowels, 2, variation)
                  .map(
                    (vowel_) => addConsonantToVowel(
                      LetterData.randomPlaceholder(random),
                      vowel_,
                    ),
                  )
                  .toList();
            }

            lessons[0].add(
              selectExercise(
                correctLetter: correctLetter,
                incorrectLetters: incorrectLetters,
                sectionType: SectionType.vowel,
                usePlaceholders: usingDefaultPlaceholder,
              ),
            );
          }
          // Alternate exercise type for variety
          isLetterMatchingExercise = !isLetterMatchingExercise;
        }
        // When the first round is complete, make the placeholder a random
        usingDefaultPlaceholder = !usingDefaultPlaceholder;
      }
    }

    for (List<String> vowel in variations) {
      for (String variation in vowel) {
        lessons[0].add(LearnVowelExercise(vowel: variation));
      }
    }

    // One set of matching game with the vowels that are combined with consonants,
    // and one set with the ones that are not
    lessons[0].add(
      MatchingExercise(
        // adds each of the vowels to the list, and randomly chooses between the
        // two variations
        lettersToMatch: {
          for (String item in variations.map(
            (variation) => variation[random.nextInt(variation.length)],
          ))
            item: SectionType.vowel,
        },
      ),
    );
    lessons[0].add(
      MatchingExercise(
        // adds each of the vowels to the list, and randomly chooses between the
        // two variations
        lettersToMatch: {
          for (String item in variations.map(
            (variation) => addConsonantToVowel(
              LetterData.randomPlaceholder(random),
              variation[random.nextInt(variation.length)],
            ),
          ))
            item: SectionType.consonant,
        },
      ),
    );

    // Second lesson
    final List<StatefulExercise> shuffledExercises = [];
    for (List<String> vowel in variations) {
      bool isLetterMatchingExercise = random.nextBool();
      bool usingDefaultPlaceholder = false;
      // Create one round for the exercises without consonants and another two for
      // the ones with them
      for (int i = 0; i < 3; i++) {
        // Create two rounds of practice exercises for each vowel variation
        for (int i = 0; i < 2; i++) {
          for (String variation in vowel) {
            // Select exercise type based on random boolean
            final selectExercise = isLetterMatchingExercise
                ? SelectLetterExercise.new
                : SelectSoundExercise.new;

            final String correctLetter;
            final List<String> incorrectLetters;
            if (usingDefaultPlaceholder) {
              correctLetter = variation;
              incorrectLetters = pickCountExcluding(vowels, 2, variation);
            } else {
              correctLetter = addConsonantToVowel(
                LetterData.randomPlaceholder(random),
                variation,
              );
              incorrectLetters = pickCountExcluding(vowels, 2, variation)
                  .map(
                    (vowel_) => addConsonantToVowel(
                      LetterData.randomPlaceholder(random),
                      vowel_,
                    ),
                  )
                  .toList();
            }

            shuffledExercises.add(
              selectExercise(
                correctLetter: correctLetter,
                incorrectLetters: incorrectLetters,
                sectionType: SectionType.vowel,
                usePlaceholders: usingDefaultPlaceholder,
              ),
            );
          }
          // Alternate exercise type for variety
          isLetterMatchingExercise = !isLetterMatchingExercise;
        }
        // When the first round is complete, make the placeholder a random
        usingDefaultPlaceholder = true;
      }
    }
    shuffledExercises.add(
      MatchingExercise(
        // adds each of the vowels to the list, and randomly chooses between the
        // two variations
        lettersToMatch: {
          for (String item in variations.map(
            (variation) => variation[random.nextInt(variation.length)],
          ))
            item: SectionType.vowel,
        },
      ),
    );
    for (int i = 0; i < 2; i++) {
      shuffledExercises.add(
        MatchingExercise(
          // adds each of the vowels to the list, and randomly chooses between the
          // two variations
          lettersToMatch: {
            for (String item in variations.map(
              (variation) => addConsonantToVowel(
                LetterData.randomPlaceholder(random),
                variation[random.nextInt(variation.length)],
              ),
            ))
              item: SectionType.vowel,
          },
        ),
      );
    }
    shuffledExercises.shuffle();
    lessons[1].addAll(shuffledExercises);
    return lessons;
  }
}
