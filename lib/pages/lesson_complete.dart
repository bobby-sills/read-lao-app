import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/utilities/sounds_utility.dart';

class LessonComplete extends StatefulWidget {
  const LessonComplete({
    super.key,
    required this.lessonNum,
    required this.sectionType,
  });
  final int lessonNum;
  final SectionType sectionType;

  @override
  State<LessonComplete> createState() => _LessonCompleteState();
}

class _LessonCompleteState extends State<LessonComplete> {
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 1),
  );
  final SoundsUtility _soundPlayer = SoundsUtility();

  @override
  void initState() {
    super.initState();
    _confettiController.play();
    _soundPlayer.playSoundEffect('complete');
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _soundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String textSectionType = widget.sectionType == SectionType.consonant
        ? "Consonant"
        : "Vowel";

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 80,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  '$textSectionType lesson ${widget.lessonNum + 1} complete!',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Well done! Keep up the great work',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    size: theme.textTheme.headlineSmall?.fontSize,
                  ),
                  iconAlignment: IconAlignment.end,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  label: Text(
                    'Back to lessons',
                    style: TextStyle(
                      fontSize: theme.textTheme.headlineSmall?.fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5, // set a lower max blast force
              minBlastForce: 2, // set a lower min blast force
              emissionFrequency: 1,
              numberOfParticles: 5, // a lot of particles at once
              gravity: 1,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }
}
