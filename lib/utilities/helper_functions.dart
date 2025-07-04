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
  // Ensure the correct letter is in the list and makes sure it doesn't get randomly drawn
  final indexes = <int>{possibleLetters.indexOf(correct)};
  result.add(correct);

  while (indexes.length < count) {
    final randomIndex = random.nextInt(possibleLetters.length);
    if (indexes.add(randomIndex)) {
      result.add(possibleLetters[randomIndex]);
    }
  }
  result
      .shuffle(); // Finally shuffles it because otherwise the correct letter is always the first one

  return result;
}

const List consonants = [
  'ກ',
  'ຂ',
  'ຄ',
  'ງ',
  'ຈ',
  'ສ',
  'ຊ',
  'ຍ',
  'ດ',
  'ຕ',
  'ຖ',
  'ທ',
  'ນ',
  'ບ',
  'ປ',
  'ຜ',
  'ຝ',
  'ພ',
  'ຟ',
  'ມ',
  'ຢ',
  'ຣ',
  'ລ',
  'ວ',
  'ຫ',
  'ອ',
  'ຮ',
];

const Map<String, String> laoToRomanization = {
  'ກ': 'ko',
  'ຂ': 'kho sung',
  'ຄ': 'kho tam',
  'ງ': 'ngo',
  'ຈ': 'co',
  'ສ': 'so sung',
  'ຊ': 'so tam',
  'ຍ': 'nyo',
  'ດ': 'do',
  'ຕ': 'to',
  'ຖ': 'tho sung',
  'ທ': 'tho tam',
  'ນ': 'no',
  'ບ': 'bo',
  'ປ': 'po',
  'ຜ': 'pho sung',
  'ຝ': 'fo tam',
  'ພ': 'pho tam',
  'ຟ': 'fo sung',
  'ມ': 'mo',
  'ຢ': 'yo',
  'ຣ': 'lo ling',
  'ລ': 'lo loot',
  'ວ': 'wo',
  'ຫ': 'ho sung',
  'ອ': 'o',
  'ຮ': 'ho tam',
};

const Map<String, String> romanizationToLao = {
  "ko": "ກ",
  "kho sung": "ຂ",
  "kho tam": "ຄ",
  "ngo": "ງ",
  "co": "ຈ",
  "so sung": "ສ",
  "so tam": "ຊ",
  "nyo": "ຍ",
  "do": "ດ",
  "to": "ຕ",
  "tho sung": "ຖ",
  "tho tam": "ທ",
  "no": "ນ",
  "bo": "ບ",
  "po": "ປ",
  "pho sung": "ຜ",
  "fo tam": "ຝ",
  "pho tam": "ພ",
  "fo sung": "ຟ",
  "mo": "ມ",
  "yo": "ຢ",
  "lo ling": "ຣ",
  "lo loot": "ລ",
  "wo": "ວ",
  "ho sung": "ຫ",
  "o": "ອ",
  "ho tam": "ຮ",
};

const String vowelPlaceholder = 'ອ';

const List<String> vowelsIndices = [
  'ອະ',
  'ອາ',
  'ອິ',
  'ອີ',
  'ອຶ',
  'ອື',
  'ອຸ',
  'ອູ',
  'ເອະ',
  'ເອ',
  'ແອະ',
  'ແອ',
  'ໂອະ',
  'ໂອ',
  'ເອາະ',
  'ອໍ',
  'ເອິ',
  'ເອີ',
  'ເອຍ',
  'ເອຶອ',
  'ອົວ',
  'ໄອ',
  'ເອົາ',
  'ອຳ',
  'ອອຍ',
  'ອວຍ',
];
