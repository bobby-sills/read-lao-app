import 'package:audioplayers/audioplayers.dart';
import 'package:learn_lao_app/enums/letter_type.dart';
import 'package:learn_lao_app/typedefs/letter_type.dart';
import 'package:learn_lao_app/utilities/letter_data.dart';

class AudioUtility {
  final audioPlayer = AudioPlayer();

  Future<void> playLetter(Letter letter) async {
    if (audioPlayer.state == PlayerState.playing) {
      await audioPlayer.stop();
    }
    await audioPlayer.play(
      AssetSource(
        letter.type == LetterType.consonant
            ? 'consonants/sounds/${LetterData.laoToRomanization[letter.character]}_normalized.wav'
            : 'vowels/sounds/${LetterData.getVowelIndex(letter.character) + 1}_normalized.wav',
      ),
    );
  }

  Future<void> playSoundEffect(String soundEffect) async {
    await audioPlayer.play(AssetSource('sound_effects/$soundEffect.wav'));
  }

  Future<void> playWord(String word) async {
    await audioPlayer.play(AssetSource('words/$word.mp3'));
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
