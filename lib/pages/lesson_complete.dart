import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class LessonComplete extends StatelessWidget {
  LessonComplete({super.key, required this.lessonNum});
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 1),
  );

  final int lessonNum;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    _confettiController.play();

    AudioPlayer().play(AssetSource('sound_effects/complete.wav'));

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lesson ${lessonNum + 1} complete!',
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(height: 20),
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
