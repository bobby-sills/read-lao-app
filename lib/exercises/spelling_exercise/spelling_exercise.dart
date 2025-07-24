import 'package:flutter/material.dart';
import 'package:local_hero/local_hero.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';

enum SectionLocation { upper, lower }

typedef LetterData = (int, LetterCard);

class SpellingExercise extends StatefulExercise {
  SpellingExercise({super.key});

  @override
  StatefulExerciseState<SpellingExercise> createState() =>
      _SpellingExerciseState();
}

class _SpellingExerciseState extends StatefulExerciseState<SpellingExercise> {
  SectionLocation sectionLocation = SectionLocation.upper;
  final List<String> availableLetters = ['a', 'b', 'c', 'd'];

  late final List<LetterData> upper;
  late final List<LetterData> lower;

  @override
  void initState() {
    super.initState();
    upper = [];
    lower = availableLetters
        .asMap()
        .entries
        .map(
          (entry) => (
            entry.key, // itemID
            LetterCard(
              swapSides: swapSides,
              letter: entry.value,
              tag: entry.key,
            ),
          ),
        )
        .toList();
  }

  void swapSides(int tag) {
    setState(() {
      late final SectionLocation location;

      // If it's in the upper list
      if (upper.any((data) => data.$1 == tag)) {
        location = SectionLocation.upper;
      } else {
        // and if not in the upper list it's in the lower list
        location = SectionLocation.lower;
      }
      final sectionFrom = (location == SectionLocation.upper) ? upper : lower;
      final sectionTo = (location == SectionLocation.upper) ? lower : upper;

      final int index = sectionFrom.indexWhere((data) => data.$1 == tag);

      sectionTo.add(sectionFrom[index]);
      sectionFrom.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LocalHeroScope(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 5,
                    children: upper.map((letter) => letter.$2).toList(),
                  ),
                ),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 2,
              child: Card(
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 5,
                    children: lower.map((letter) => letter.$2).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget bottomSheetContent(BuildContext context) {
    return Text("test");
  }
}

class LetterCard extends StatelessWidget {
  const LetterCard({
    super.key,
    required this.swapSides,
    required this.tag,
    required this.letter,
  });

  final void Function(int tag) swapSides;
  final int tag;
  final String letter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LocalHero(
      tag: tag,
      child: GestureDetector(
        onTap: () => swapSides(tag),
        child: Card(
          color: Colors.blue,
          child: SizedBox(
            height: 100,
            width: 100,
            child: Center(
              child: Text(letter, style: theme.textTheme.displayLarge),
            ),
          ),
        ),
      ),
    );
  }
}
