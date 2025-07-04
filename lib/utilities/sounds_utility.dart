import 'package:audioplayers/audioplayers.dart' show AssetSource, AudioPlayer;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:learn_lao_app/utilities/helper_functions.dart';

class SoundsUtility {
  final audioPlayer = AudioPlayer();

  Future<void> playLetter(String letter) async {
    try {
      await audioPlayer.play(
        AssetSource('letters/sounds/${laoToRomanization[letter]}.wav'),
      );
    } catch (e) {
      if (kDebugMode) {
        print(
          "Error: file 'assets/letters/sounds/${laoToRomanization[letter]}.wav' not found",
        );
      }
    }
  }

  Future<void> playVowel(int letterIndex) async {
    letterIndex =
        letterIndex + 1; // Because the file names start at index 1 not 0
    // Convert the lao
    try {
      await audioPlayer.play(AssetSource('vowels/sounds/$letterIndex.mp3'));
    } catch (e) {
      if (kDebugMode) {
        print("Error: file 'assets/vowels/sounds/$letterIndex.mp3' not found");
      }
    }
  }

  Future<void> playSoundEffect(String soundEffect) async {
    try {
      await audioPlayer.play(AssetSource('sound_effects/$soundEffect.wav'));
    } catch (e) {
      if (kDebugMode) {
        print("Error: file 'assets/sound_effects/$soundEffect.wav' not found");
      }
    }
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
