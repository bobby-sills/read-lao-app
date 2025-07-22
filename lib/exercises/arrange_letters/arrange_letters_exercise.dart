import 'package:flutter/material.dart';
import 'package:learn_lao_app/exercises/arrange_letters/draggable_letter.dart';
import 'package:learn_lao_app/exercises/arrange_letters/types.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';

class ArrangeLettersExercise extends StatefulExercise {
  ArrangeLettersExercise({super.key});

  @override
  State<ArrangeLettersExercise> createState() => _ArrangeLettersExerciseState();
}

class _ArrangeLettersExerciseState extends State<ArrangeLettersExercise> {
  final List<String> upper = [];
  final List<String> lower = ['a', 'b', 'c', 'd'];

  final int columns = 4;
  final double itemSpacing = 8.0;

  DropLocation? dragStart;
  String? hoveringData;

  void onDragStart(DropLocation start) {
    final data = switch (start.$2) {
      Section.upper => upper[start.$1],
      Section.lower => lower[start.$1],
    };

    setState(() {
      dragStart = start;
      hoveringData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Card(
                    child: LetterDropRegion(
                      onDragStart: onDragStart,
                      section: Section.upper,
                      crossAxisCount: columns,
                      letters: upper,
                      padding: 4.0,
                      spacing: 4.0,
                      constraints: constraints,
                      dragStart: dragStart?.$2 == Section.upper
                          ? dragStart
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: theme.colorScheme.outline,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: LetterDropRegion(
                          onDragStart: onDragStart,
                          section: Section.lower,
                          crossAxisCount: columns,
                          padding: 4.0,
                          spacing: 4.0,
                          letters: lower,
                          constraints: constraints,
                          dragStart: dragStart?.$2 == Section.lower
                              ? dragStart
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LetterDropRegion extends StatelessWidget {
  const LetterDropRegion({
    super.key,
    required this.onDragStart,
    required this.section,
    required this.crossAxisCount,
    required this.padding,
    required this.spacing,
    required this.letters,
    required this.constraints,
    required this.dragStart,
  });

  final void Function(DropLocation) onDragStart;
  final Section section;
  final int crossAxisCount;
  final double padding;
  final double spacing;
  final List<String> letters;
  final BoxConstraints constraints;
  final DropLocation? dragStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double cardArea = constraints.maxWidth - (padding * 2);
    final int numOfSpaces = crossAxisCount + 1;
    final double cardSize =
        (cardArea - (spacing * numOfSpaces * 2)) / crossAxisCount;

    DropLocation? dragStartCopy;
    if (dragStart != null) {
      dragStartCopy = dragStart!.copyWith();
    }
    return GridView.count(
      crossAxisCount: crossAxisCount,
      children: letters.asMap().entries.map((entry) {
        late final Widget child;
        if (entry.key == dragStartCopy?.$1) {
          child = SizedBox.shrink();
        } else {
          child = SizedBox.square(
            dimension: cardSize,
            child: Card(
              color: theme.colorScheme.secondaryContainer,
              child: Center(child: Text(entry.value)),
            ),
          );
          ;
        }

        return Draggable(
          feedback: child,
          child: DraggableLetter(
            onDragStart: () => onDragStart((entry.key, section)),
            data: entry.value,
            child: child,
          ),
        );
      }).toList(),
    );
  }
}
