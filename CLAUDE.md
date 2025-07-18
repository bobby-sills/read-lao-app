# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application for learning the Lao language through interactive exercises. The app teaches Lao letters through various exercise types including letter recognition, sound matching, and visual matching exercises.

## Development Commands

### Build and Run

```bash
flutter run                    # Run the app in debug mode
## Always use the run mode when trying to debug the app instead of building, and if no emulators are open the medium emulator
```

### Development Tools

```bash
flutter pub get              # Install dependencies
flutter pub upgrade          # Upgrade dependencies
flutter clean                # Clean build files
flutter analyze              # Run static analysis
dart format .                # Format code
```

### Testing

```bash
flutter test                 # Run unit tests
flutter test --coverage     # Run tests with coverage
```,

## Code Architecture

### Core Structure

- **main.dart**: App entry point, initializes Hive local storage and MaterialApp
- **pages/**: Main application screens with bottom navigation (Home, Practice, Settings)
- **exercises/**: Different exercise types that inherit from StatefulExercise base class
- **components/**: Reusable UI components like buttons and text widgets
- **utilities/**: Helper classes for data management, sounds, and app state

### Key Design Patterns

**Exercise System**: All exercises inherit from `StatefulExercise` abstract class which provides:

- Unique key generation for proper widget rebuilding
- Bottom sheet functionality for exercise feedback
- Consistent state management across exercise types

**Data Management**:

- `AppData` class contains static lesson data organized as List<List<StatefulExercise>>
- `HiveUtility` manages local storage for lesson completion tracking
- Provider pattern used for lesson state management via `LessonProvider`

**Asset Organization**:

- `assets/letters/`: Contains SVG images, PNG images, and WAV audio files for each Lao letter
- `assets/fonts/`: Lao-specific fonts (Saysettha, NotoSerifLao)
- `assets/sound_effects/`: UI feedback sounds (correct, incorrect, complete)

### Exercise Types

- `LearningExercise`: Introduction to new letters with visual and audio
- `SelectLetterExercise`: Multiple choice letter recognition
- `SelectSoundExercise`: Audio-based letter identification  
- `MatchingExercise`: Drag-and-drop letter matching
- `LearnVowelExercise`: Vowel-specific learning exercises

### Navigation Structure

App uses bottom navigation with three main sections:

- **HomePage**: Lesson progression and access
- **PracticePage**: Practice exercises
- **SettingsPage**: App configuration

### State Management

- Provider pattern for lesson state via `LessonProvider`
- Hive for persistent local storage (lesson completion)
- StatefulWidget pattern for individual exercises

### Audio System

`SoundsUtility` class handles:

- Letter pronunciation via `playLetter(String letter)`
- UI sound effects via `playSoundEffect(String soundEffect)`
- Uses `audioplayers` package with AssetSource for local audio files

## Key Dependencies

- `provider`: State management
- `flutter_svg`: SVG image rendering for Lao letters
- `audioplayers`: Audio playback for pronunciation and effects
- `hive_flutter`: Local data persistence
- `confetti`: Celebration animations
- `fluttertoast`: User feedback messages
- `auto_size_text`: Responsive text sizing

