import 'package:audioplayers/audioplayers.dart' show AssetSource, AudioPlayer;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/utilities/letter_data.dart';

class SoundsUtility {
  final audioPlayer = AudioPlayer();

  Future<void> playLetter(String letter, SectionType sectionType) async {
    await audioPlayer.play(
      AssetSource(
        sectionType == SectionType.consonant
            ? 'letters/sounds/${LetterData.laoToRomanization[letter]}.wav'
            : 'vowels/sounds/${LetterData.vowelsIndices.indexOf(letter)}',
      ),
    );
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
    await audioPlayer.play(AssetSource('sound_effects/$soundEffect.wav'));
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
