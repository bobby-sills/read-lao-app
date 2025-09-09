import 'package:audioplayers/audioplayers.dart' show AssetSource, AudioPlayer;
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/utilities/letter_data.dart';

class SoundsUtility {
  final audioPlayer = AudioPlayer();

  Future<void> playLetter(String letter, SectionType sectionType) async {
    await audioPlayer.play(
      AssetSource(
        sectionType == SectionType.consonant
            ? 'consonants/sounds/${LetterData.laoToRomanization[letter]}.wav'
            : 'vowels/sounds/${LetterData.getVowelIndex(letter) + 1}.wav',
      ),
    );
  }

  Future<void> playSoundEffect(String soundEffect) async {
    await audioPlayer.play(AssetSource('sound_effects/$soundEffect.wav'));
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
