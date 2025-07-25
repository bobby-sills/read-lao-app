import 'package:flutter/material.dart';
import 'package:local_hero/local_hero.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';

enum SectionLocation { upper, lower }

class SpellingExerciseTest extends StatefulExercise {
  SpellingExerciseTest({super.key});

  @override
  StatefulExerciseState<SpellingExerciseTest> createState() =>
      _SpellingExerciseState();
}

class _SpellingExerciseState
    extends StatefulExerciseState<SpellingExerciseTest> {
  late final List<LetterCard> upper;
  late final List<LetterCard> lower;

  @override
  void initState() {
    super.initState();
    setState(() {
      upper = [];
      lower = [LetterCard(onTap: swapSides, letter: 'a')];
    });
  }

  void swapSides() {
    setState(() {
      if (lower.isEmpty) {
        lower.add(upper[0]);
        upper.removeAt(0);
      } else {
        upper.add(lower[0]);
        lower.removeAt(0);
      }
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
                  child: GridView.count(crossAxisCount: 5, children: upper),
                ),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 2,
              child: Card(
                child: Center(
                  child: GridView.count(crossAxisCount: 5, children: lower),
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
  const LetterCard({super.key, required this.onTap, required this.letter});

  final void Function() onTap;
  final String letter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LocalHero(
      tag: letter,
      child: GestureDetector(
        onTap: onTap,
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
