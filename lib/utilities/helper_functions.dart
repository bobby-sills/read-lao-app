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

const List<String> teachingOrder = [
  'ກ', // g/k sound
  'ງ', // visually distinct spacer
  'ຂ', // g/k sound (pair with ກ but spaced)
  'ຈ', // visually distinct spacer
  'ຄ', // g/k sound (final of this group)
  'ສ', // visually distinct spacer
  'ຟ', // f/ph sound
  'ດ', // visually distinct spacer
  'ຝ', // f/ph sound (pair with ຟ)
  'ນ', // visually distinct spacer
  'ປ', // p/bp sound
  'ຣ', // visually distinct spacer
  'ບ', // p/bp sound (pair with ປ)
  'ລ', // visually distinct spacer
  'ພ', // p/bp sound (final of this group)
  'ວ', // visually distinct spacer
  'ຕ', // t sound
  'ຊ', // visually distinct spacer
  'ທ', // t sound (pair with ຕ)
  'ມ', // visually distinct spacer
  'ຖ', // t sound (final of this group)
  'ອ', // visually distinct spacer
  'ຍ', // y/ny sound
  'ຜ', // visually distinct spacer
  'ຢ', // y/ny sound (pair with ຍ)
  'ຫ', // h sound
  'ຮ', // h sound (pair with ຫ but spaced at end)
];

const Map<String, String> lettersToWords = {
  'ກ': 'ໄກ່',
  'ຂ': 'ໄຂ່',
  'ຄ': 'ຄວາຍ',
  'ງ': 'ງູ',
  'ຈ': 'ຈອກ',
  'ສ': 'ເສືອ',
  'ຊ': 'ຊ້າງ',
  'ຍ': 'ຍຸງ',
  'ດ': 'ເດັກ',
  'ຕ': 'ຕາ',
  'ຖ': 'ຖົງ',
  'ທ': 'ທຸງ',
  'ນ': 'ນົກ',
  'ບ': 'ແບ້',
  'ປ': 'ປາ',
  'ຜ': 'ເຜິ້ງ',
  'ຝ': 'ຝົນ',
  'ພ': 'ພູ',
  'ຟ': 'ໄຟ',
  'ມ': 'ແມວ',
  'ຢ': 'ຢາ',
  'ຣ': 'ຣະຄັງ',
  'ລ': 'ລີງ',
  'ວ': 'ວີ',
  'ຫ': 'ຫ່ານ',
  'ອ': 'ອື່ງ',
  'ຮ': 'ເຮືອ',
};

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

const String vowelPlaceholder = '◌';

const List<String> vowelsIndices = [
  '◌ະ',
  '◌າ',
  '◌ິ',
  '◌ີ',
  '◌ຶ',
  '◌ື',
  '◌ຸ',
  '◌ູ',
  'ເ◌ະ',
  'ເ◌',
  'ແ◌ະ',
  'ແ◌',
  'ໂ◌ະ',
  'ໂ◌',
  'ເ◌າະ',
  '◌ໍ',
  'ເ◌ິ',
  'ເ◌ີ',
  'ເ◌ຍ',
  'ເ◌ຶ◌',
  '◌ົວ',
  'ໄ◌',
  'ເ◌ົາ',
  '◌ຳ',
  '◌◌ຍ',
  '◌ວຍ',
];
// const List<String> vowelsIndices = [
//   'ອະ',
//   'ອາ',
//   'ອິ',
//   'ອີ',
//   'ອຶ',
//   'ອື',
//   'ອຸ',
//   'ອູ',
//   'ເອະ',
//   'ເອ',
//   'ແອະ',
//   'ແອ',
//   'ໂອະ',
//   'ໂອ',
//   'ເອາະ',
//   'ອໍ',
//   'ເອິ',
//   'ເອີ',
//   'ເອຍ',
//   'ເອຶອ',
//   'ອົວ',
//   'ໄອ',
//   'ເອົາ',
//   'ອຳ',
//   'ອອຍ',
//   'ອວຍ',
// ];
