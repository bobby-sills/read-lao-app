import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_lao/utilities/audio_utility.dart';
import 'package:read_lao/exercises/stateful_exercise.dart';
import 'package:read_lao/components/bottom_lesson_button.dart';
import 'package:read_lao/utilities/provider/lesson_provider.dart';

enum CardState { on, off }

class SpellingExercise extends StatefulExercise {
  final String word;

  SpellingExercise({super.key, required this.word});

  @override
  StatefulExerciseState<SpellingExercise> createState() =>
      _SpellingExerciseState();
}

class _SpellingExerciseState extends StatefulExerciseState<SpellingExercise> {
  late final List<int> tray;
  late final List<CardState> states;
  late final List<int> shuffledIndices;
  final List<int> clickOrder = [];
  bool bottomButtonIsCorrect = true;
  final AudioUtility effectPlayer = AudioUtility();
  final AudioUtility speechPlayer = AudioUtility();
  int incorrectCount = 0;

  @override
  initState() {
    super.initState();
    tray = widget.word.runes.toList();
    states = List.filled(tray.length, CardState.on);
    shuffledIndices = List.generate(tray.length, (index) => index);
    shuffledIndices.shuffle();
  }

  String get _displayText {
    return String.fromCharCodes(
      clickOrder.expand(
        (index) => states[index] == CardState.off ? [tray[index]] : <int>[],
      ),
    );
  }

  String laoRuneToDisplayString(int rune) {
    const Set<int> laoCombiningMarks = {
      0x0EB1,
      0x0EB4,
      0x0EB5,
      0x0EB6,
      0x0EB7,
      0x0EBB,
      0x0EB8,
      0x0EB9,
      0x0EBC,
      0x0EC8,
      0x0EC9,
      0x0ECA,
      0x0ECB,
      0x0ECC,
      0x0ECD,
    };

    const String dottedCircle = '\u25CC';

    if (laoCombiningMarks.contains(rune)) {
      return dottedCircle + String.fromCharCode(rune);
    } else {
      return String.fromCharCode(rune);
    }
  }

  void _onCardTap(int index) {
    setState(() {
      if (states[index] == CardState.on) {
        states[index] = CardState.off;
        clickOrder.add(index);
      } else {
        states[index] = CardState.on;
        clickOrder.remove(index);
      }
    });
  }

  Future<void> _playWord() async {
    await speechPlayer.playWord(widget.word);
  }

  void checkAnswer() {
    final bool isCorrect = _displayText == widget.word;

    if (isCorrect) {
      effectPlayer.playSoundEffect('correct');
      setState(() => bottomButtonIsCorrect = true);
    } else {
      incorrectCount++;
      effectPlayer.playSoundEffect('incorrect');
      setState(() => bottomButtonIsCorrect = false);
      context.read<LessonProvider>().markExerciseAsMistake?.call();
    }
    showBottomBar(
      context: context,
      onShow: () {
        Provider.of<LessonProvider>(
          context,
          listen: false,
        ).setBottomSheetVisible(true);
      },
      onHide: () {
        Provider.of<LessonProvider>(
          context,
          listen: false,
        ).setBottomSheetVisible(false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  onPressed: _playWord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  child: Icon(Icons.volume_up_rounded, size: 48),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    padding: EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        _displayText,
                        style: TextStyle(
                          fontFamily: "NotoSansLaoLooped",
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  for (
                    int displayIndex = 0;
                    displayIndex < tray.length;
                    displayIndex++
                  )
                    GestureDetector(
                      onTap: () => _onCardTap(shuffledIndices[displayIndex]),
                      child: Card(
                        elevation:
                            states[shuffledIndices[displayIndex]] ==
                                CardState.on
                            ? 4.0
                            : 0.0,
                        color:
                            states[shuffledIndices[displayIndex]] ==
                                CardState.on
                            ? null
                            : theme.colorScheme.surfaceContainerHighest,
                        child: Center(
                          child: Text(
                            laoRuneToDisplayString(
                              tray[shuffledIndices[displayIndex]],
                            ),
                            style: TextStyle(
                              fontFamily: "NotoSansLaoLooped",
                              fontWeight: FontWeight.w500,
                              fontSize: 36,
                              color:
                                  states[shuffledIndices[displayIndex]] ==
                                      CardState.on
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SafeArea(
                child: BottomLessonButton(
                  onPressed: _displayText == '' ? null : checkAnswer,
                  buttonText: 'Check',
                  buttonIcon: const Icon(Icons.check_rounded),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8),
        Text(
          bottomButtonIsCorrect ? 'Correct!' : 'Incorrect!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        BottomLessonButton(
          onPressed: bottomButtonIsCorrect
              ? context.read<LessonProvider>().nextExercise!
              : Navigator.of(context).pop,
          buttonIcon: bottomButtonIsCorrect
              ? const Icon(Icons.arrow_forward_rounded)
              : const Icon(Icons.refresh_rounded),
          buttonText: bottomButtonIsCorrect ? 'Continue' : 'Try Again',
          buttonColor: bottomButtonIsCorrect
              ? Colors.greenAccent
              : Colors.redAccent,
        ),
        SizedBox(height: 8),
        BottomLessonButton(
          onPressed: context.read<LessonProvider>().nextExercise!,
          buttonIcon: const Icon(Icons.skip_next),
          buttonText: 'Skip',
          buttonColor: Colors.orangeAccent,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    effectPlayer.dispose();
    speechPlayer.dispose();
    super.dispose();
  }
}
