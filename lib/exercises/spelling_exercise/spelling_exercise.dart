import 'package:flutter/material.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';

class SpellingExercise extends StatefulExercise {
  SpellingExercise({super.key});

  @override
  StatefulExerciseState<SpellingExercise> createState() =>
      _SpellingExerciseState();
}

class _SpellingExerciseState extends StatefulExerciseState<SpellingExercise> {
  static const int _columns = 4;
  static const double _margin = 8.0;

  final topTray = [];
  final bottomTray = ['a', 'b', 'c', 'd', 'f', 'g'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(
          () => bottomTray.removeAt((bottomTray.length / 2).toInt()),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, contraints) {
          final double cardSize =
              (contraints.maxWidth - (_margin * (_columns + 1))) / _columns;
          return Stack(
            children: [
              for (int i = 0; i < bottomTray.length; i++)
                AnimatedPositioned(
                  left: ((cardSize + _margin) * i) + _margin,
                  bottom: ((i % _columns)) * cardSize,
                  duration: Duration(milliseconds: 100),
                  child: SizedBox.square(
                    dimension: cardSize,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Center(child: Text(bottomTray[i])),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget bottomSheetContent(BuildContext context) {
    return Placeholder();
  }
}
