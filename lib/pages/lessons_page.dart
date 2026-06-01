import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:read_lao/components/animal_illustration.dart';
import 'package:read_lao/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:read_lao/utilities/lesson_data.dart';
import 'package:read_lao/utilities/hive_utility.dart';
import 'package:read_lao/components/lesson_nav_button.dart';
import 'package:read_lao/utilities/letter_data.dart';

enum LessonStatus { notStarted, nextUp, completed }

// Same formula used inside the itemBuilder. Extracted so we can look at
// neighbouring rows when deciding where to anchor decorative illustrations.
double _xOffsetForIndex(int index) {
  final int offsetIndex = index >= LessonData.consonantLessons.length
      ? index - LessonData.consonantLessons.length
      : index;
  return sin(offsetIndex * 100) * 96;
}

// A row is a peak/valley if its lesson sits further to one side than both
// neighbours and is meaningfully off-centre. These are the rows where there's
// the most empty space opposite the curve's outer edge — the right place to
// anchor a big illustration, like Duolingo does at each bend in its path.
bool _isPathPeak(int index, int total) {
  if (index <= 0 || index >= total - 1) return false;
  final x = _xOffsetForIndex(index);
  final absX = x.abs();
  if (absX < 60) return false;
  final prevAbs = _xOffsetForIndex(index - 1).abs();
  final nextAbs = _xOffsetForIndex(index + 1).abs();
  return absX >= prevAbs && absX >= nextAbs;
}

// Only animals that appear in the Lao letter/word mnemonics taught in this app.
// See LetterData.lettersToWords and LetterData.vowelWords / spellingWords for
// the curriculum mapping. Tiger / elephant / frog are reused here even though
// they also anchor specific screens (streak, consonants header, vowels header).
const List<String> _decorAnimals = [
  'assets/animals/cat.svg',       // ແມວ (ມ)
  'assets/animals/chicken.svg',   // ໄກ່ (ກ)
  'assets/animals/cow.svg',       // ງົວ (ງ)
  'assets/animals/duck.svg',      // ຫ່ານ (ຫ) — goose stand-in
  'assets/animals/elephant.svg',  // ຊ້າງ (ຊ)
  'assets/animals/frog.svg',      // ກົບ
  'assets/animals/goat.svg',      // ແບ້ (ບ)
  'assets/animals/monkey.svg',    // ລີງ (ລ)
  'assets/animals/mouse.svg',     // ໜູ
  'assets/animals/parrot.svg',    // ນົກ (ນ) — generic bird
  'assets/animals/pig.svg',       // ໝູ
  'assets/animals/tiger.svg',     // ເສືອ (ສ)
  'assets/animals/turtle.svg',    // ເຕົ່າ
  'assets/animals/bear.svg',      // ໝີ
  'assets/animals/dog.svg',       // ໝາ
  'assets/animals/lion.svg',      // ສິງ
  'assets/animals/crab.svg',      // ປູ
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int lessonButtonSize = 100;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    final lastLessonIndex = HiveUtility.getLastLessonComplete();

    // Calculate the position based on lesson index
    double targetPosition =
        lastLessonIndex * 120.0; // 100 lesson height + 20 padding

    // Add some offset to center the lesson on screen
    targetPosition = (targetPosition - 200).clamp(0, double.infinity);

    _scrollController = ScrollController(initialScrollOffset: targetPosition);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: LessonData.allLessons.length,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                    valueListenable: Hive.box<bool>(
                      HiveUtility.lessonCompletionBox,
                    ).listenable(),
                    builder:
                        (BuildContext context, Box<bool> box, Widget? child) {
                          final double xOffset = _xOffsetForIndex(index);
                          final lessonStatus =
                              HiveUtility.isLessonCompleted(index)
                              ? LessonStatus.completed
                              : HiveUtility.isLessonCompleted(index - 1)
                              ? LessonStatus.nextUp
                              : index == 0
                              ? LessonStatus.nextUp
                              : LessonStatus.notStarted;

                          Widget lessonButton = SizedBox(
                            width: 100,
                            height: 100,
                            child: LessonNavButton(
                              character:
                                  index <
                                      LetterData.consonantTeachingOrder.length
                                  ? LetterData.consonantTeachingOrder[index]
                                  : LetterData.vowelTeachingOrder[index -
                                        LetterData
                                            .consonantTeachingOrder
                                            .length],
                              index: index,
                              lessonStatus: lessonStatus,
                            ),
                          );

                          // Anchor a big animal at each peak/valley of the
                          // snaking path. Place it on the OPPOSITE side from
                          // the bend, filling the open space that the curve
                          // leaves behind — like Duolingo's illustrations.
                          final bool showDecor = _isPathPeak(
                            index,
                            LessonData.allLessons.length,
                          );
                          final String decorAsset =
                              _decorAnimals[index % _decorAnimals.length];
                          const double decorSize = 120;
                          final double decorXOffset =
                              xOffset >= 0 ? -140.0 : 140.0;

                          final tmpButton = Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              height: 100,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  if (showDecor)
                                    Transform.translate(
                                      offset: Offset(decorXOffset, 0),
                                      child: SvgPicture.asset(
                                        decorAsset,
                                        width: decorSize,
                                        height: decorSize,
                                      ),
                                    ),
                                  Transform.translate(
                                    offset: Offset(xOffset, 0),
                                    child: lessonButton,
                                  ),
                                ],
                              ),
                            ),
                          );

                          final l10n = AppLocalizations.of(context)!;
                          if (index == LessonData.consonantLessons.length) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const AnimalIllustration(
                                        asset: 'assets/animals/frog.svg',
                                        size: 56,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        l10n.vowels,
                                        style: theme.textTheme.titleLarge,
                                      ),
                                    ],
                                  ),
                                ),
                                tmpButton,
                              ],
                            );
                          } else if (index == 0) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const AnimalIllustration(
                                        asset: 'assets/animals/chicken.svg',
                                        size: 56,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        l10n.consonants,
                                        style: theme.textTheme.titleLarge,
                                      ),
                                    ],
                                  ),
                                ),
                                tmpButton,
                              ],
                            );
                          } else {
                            return tmpButton;
                          }
                        },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
