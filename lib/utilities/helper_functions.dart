// A function that takes in a list and returns the shuffled version of it

import 'package:learn_lao_app/utilities/letter_data.dart';

List<T> shuffleList<T>(List<T> list) {
  return List.from(list)..shuffle();
}

// Generates a unique list of random `count` values drawn from allOptions
// excluding the `correct` value. The `correct` value is always included in the
// returned list.

// Type-safe version that maintains the input list type
List<T> pickCountExcluding<T>(List<T> list, int count, T correct) {
  List<T> uniqueItems = list.toSet().toList();
  uniqueItems.remove(correct);
  uniqueItems.shuffle();
  return uniqueItems.take(count).toList();
}

String addConsonantToVowel(String consonant, String vowel) {
  // First separate the string into different runes
  // Then find the rune that is equal to the placeholder
  // and change it
  // Then turn the runes back into a string
  final vowelAsRunes = vowel.runes.toList();
  final defaultPlaceholderRune = LetterData.vowelPlaceholder.runes.single;
  final defaultPlaceholderIndex = vowelAsRunes.indexWhere(
    (rune) => rune == defaultPlaceholderRune,
  );
  // Replace the default placeholder rune with the custom placeholder rune
  vowelAsRunes[defaultPlaceholderIndex] = consonant.runes.single;
  return String.fromCharCodes(vowelAsRunes);
}
