// A function that takes in a list and returns the shuffled version of it
import 'dart:math';

List shuffleList(List list) {
  list.shuffle();
  return list;
}

// Generates a unique list of random `count` values drawn from allOptions
// excluding the `correct` value. The `correct` value is always included in the
// returned list.
List<String> getExerciseOptions<T>(
  List<String> possibleLetters,
  int count,
  String correct,
) {
  final random = Random();
  final result = <String>[];
  List<String> uniqueLetters = possibleLetters.toSet().toList();

  // Check if correct is in the list
  if (!uniqueLetters.contains(correct)) {
    throw ArgumentError('correct value must be in possibleLetters');
  }

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
