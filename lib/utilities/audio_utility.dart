import 'package:audioplayers/audioplayers.dart';
import 'package:read_lao/enums/letter_type.dart';
import 'package:read_lao/typedefs/letter_type.dart';
import 'package:read_lao/utilities/letter_data.dart';

class AudioUtility {
  final audioPlayer = AudioPlayer();

  Future<void> playLetter(Letter letter) async {
    if (audioPlayer.state == PlayerState.playing) {
      await audioPlayer.stop();
    }
    await audioPlayer.play(
      AssetSource(
        letter.type == LetterType.consonant
            ? 'consonants/sounds/${LetterData.laoToRomanization[letter.character]}.wav'
            : 'vowels/sounds/${LetterData.getVowelIndex(letter.character) + 1}.wav',
      ),
    );
  }

  Future<void> playSoundEffect(String soundEffect) async {
    late final String filename;
    switch (soundEffect) {
      case "correct":
        filename = "correct.wav";
        break;
      case "complete":
        filename = "complete.wav";
        break;
      case "incorrect":
        filename = "incorrect.wav";
        break;
      default:
    }
    await audioPlayer.play(AssetSource('sound_effects/$filename'));
  }

  Future<void> playWord(String word) async {
    await audioPlayer.play(AssetSource('words/$word.mp3'));
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
