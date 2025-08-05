// A function that takes in a list and returns the shuffled version of it
import 'dart:math';

import 'package:learn_lao_app/utilities/letter_data.dart';

List shuffleList(List list) {
  list.shuffle();
  return list;
}

// Generates a unique list of random `count` values drawn from allOptions
// excluding the `correct` value. The `correct` value is always included in the
// returned list.

extension pickCountIncluding on List {}

List<String> pickCountIncluding<T>(
  List<String> possibleLetters,
  int count,
  String correct,
) {
  final random = Random();
  final result = <String>[];
  List<String> uniqueLetters = possibleLetters.toSet().toList();
  final List<int> randomIndicies = List.generate(
    uniqueLetters.length,
    (i) => i,
  );
  randomIndicies.shuffle();
  return randomIndicies.sublist();

  if (count > uniqueLetters.length) {
    count = uniqueLetters.length;
  }

  final indexes = <int>{uniqueLetters.indexOf(correct)};
  result.add(correct);

  while (indexes.length < count) {
    final randomIndex = random.nextInt(uniqueLetters.length);
    if (indexes.add(randomIndex)) {
      result.add(uniqueLetters[randomIndex]);
    }
  }

  result.shuffle();
  return result;
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
