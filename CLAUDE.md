# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application for learning the Lao language through interactive exercises. The app teaches Lao letters through various exercise types including letter recognition, sound matching, and visual matching exercises.

## Development Commands

### Build and Run

```bash
flutter run                    # Run the app in debug mode
# Always use run mode instead of build when debugging. If no emulator is open, use the medium emulator.
flutter run --release         # Build release APK/IPA
```

### Development Tools

```bash
flutter pub get              # Install dependencies
flutter pub upgrade          # Upgrade dependencies
flutter clean                # Clean build files
flutter analyze              # Run static analysis
dart format .                # Format code (applies to entire codebase)
```

### Testing

```bash
flutter test                 # Run all unit tests
flutter test --coverage      # Run tests with coverage report
```

## Code Architecture

### Overall Structure

The app follows a layered architecture:

```
Presentation (pages, components) → Business Logic (exercises, lesson generation) → Data (utilities, Hive)
```

**Key directories**:
- **main.dart**: Entry point - initializes Hive boxes and sets up MultiProvider
- **pages/**: Application screens (HomePage, SettingsPage, LessonWrapper)
- **exercises/**: Exercise implementations (all inherit from StatefulExercise)
- **lesson_generators/**: Dynamically generates lesson sequences
- **components/**: Reusable UI widgets (buttons, text components)
- **utilities/**: Data management, audio, storage, styling
- **enums/**: Letter types, button states

### Navigation Architecture

App uses bottom navigation (DefaultPage widget) with page switching:
- **HomePage (lessons_page.dart)**: Grid of lesson buttons with completion status, auto-scrolls to next incomplete lesson
- **SettingsPage (settings_page.dart)**: Theme toggle, data reset options
- **LessonWrapper**: Displays exercise sequences, manages progression, marks lessons complete
- **LessonCompletePage**: Celebration screen with confetti on lesson completion

### Exercise System Pattern

All exercises inherit from `StatefulExercise` abstract class:

- **Unique Key Generation**: Each exercise gets `UniqueKey()` to force proper widget rebuilding
- **Bottom Sheet Feedback**: `showBottomBar()` displays feedback messages with onShow/onHide callbacks
- **Consistent Structure**: `bottomSheetContent()` and `build()` are abstract, implemented by subclasses

**Exercise Types**:
- `LearnConsonantExercise` / `LearnVowelExercise`: Visual + audio introduction
- `SelectLetterExercise`: Multiple choice letter recognition
- `SelectSoundExercise`: Audio-based letter identification
- `MatchingExercise`: Drag-and-drop letter pairing
- `SpellingExercise`: Word spelling with letter combinations

### Lesson Generation and Data Management

**LessonGenerator** (lesson_generators/lesson_generator.dart):
- Dynamically creates lesson sequences in pedagogical order:
  1. Learn new consonants/vowels
  2. Exercise pairs (SelectSound + SelectLetter for newly learned letters)
  3. Matching exercises (all currently learned letters)
  4. Spelling exercises (with learned letters)
  5. Review matching exercises

**LessonData** (utilities/lesson_data.dart):
- Static List<List<StatefulExercise>> organizing lessons by category
- Separate consonantLessons and vowelLessons

**LetterData** (utilities/letter_data.dart):
- Defines 33 consonants in teaching order (includes compound forms)
- Maps each consonant to: example words, romanized pronunciation, vowel variations
- Placeholder consonants for spelling exercises

### State Management

**Provider Pattern**:
- `ThemeProvider`: Manages dark/light mode, persists to Hive 'settings' box
- `LessonProvider`: Holds callbacks (nextExercise, markExerciseAsMistake) for exercise navigation

**Hive Persistence**:
- `lesson_completion` box: Boolean map of lesson index → completion status
- `settings` box: User preferences (theme)
- `HiveUtility` provides convenience methods: isLessonCompleted(), setLessonCompleted(), getLastLessonComplete(), clearAllData()

**Reactive Updates**:
- HomePage uses `ValueListenableBuilder` on Hive box for real-time lesson status updates

### Audio System (AudioUtility)

Three main methods:
- `playLetter(Letter)`: Consonant (assets/consonants/sounds/{romanization}.wav) or vowel (assets/vowels/sounds/{index}.wav)
- `playSoundEffect(String)`: UI feedback sounds (correct/incorrect/complete)
- `playWord(String)`: Word pronunciation (assets/words/{word}.mp3)

Uses AudioPlayer singleton with AssetSource for all audio.

### Asset Organization

```
assets/
├── consonants/images/      # SVG/PNG images for consonants
├── consonants/sounds/      # WAV audio files for consonant pronunciation
├── vowels/sounds/          # WAV audio files for vowel pronunciation
├── words/                  # MP3 files for word pronunciation
├── sound_effects/          # Correct/incorrect/complete WAV files
└── fonts/NotoSansLaoLooped/  # Lao-specific font files
```

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management (ThemeProvider, LessonProvider) |
| `audioplayers` | Audio playback for letter pronunciation and UI feedback |
| `hive_flutter` | Local database for lesson completion and settings |
| `confetti` | Celebration animations on lesson completion |
| `fluttertoast` | Toast notifications for user feedback |
| `collection` | Utility functions (used for shuffling) |
| `haptic_feedback` | Vibration feedback for interactions |
| `flutter_svg` | SVG rendering (included for future use) |

## Important Implementation Notes

### Adding New Exercises

1. Create a new class extending `StatefulExercise`
2. Implement `bottomSheetContent()` (feedback UI) and `build()` (exercise UI)
3. Add to lesson generation in `LessonGenerator.generateLesson()`
4. Ensure exercise calls `context.read<LessonProvider>().nextExercise()` when complete

### Adding New Letters

1. Add letter definition to `LetterData` (consonant teaching order or vowel mapping)
2. Add pronunciation audio file to appropriate `assets/` directory
3. Update `LessonGenerator` to include new letter in appropriate lesson position
4. Add corresponding images/icons to assets if needed

### Adding Audio Assets

- Consonant audio: `assets/consonants/sounds/{romanization}.wav`
- Vowel audio: `assets/vowels/sounds/{index}.wav`
- Effects: `assets/sound_effects/{name}.wav`
- Words: `assets/words/{word}.mp3`

