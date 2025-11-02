import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DebugProvider extends ChangeNotifier {
  static const String _debugSettingsBox = 'debug_settings';
  static const String _showExerciseIncrementorKey = 'showExerciseIncrementor';

  late Box _debugBox;
  bool _showExerciseIncrementor = false;

  bool get showExerciseIncrementor => _showExerciseIncrementor;

  DebugProvider() {
    _loadDebugSettings();
  }

  void _loadDebugSettings() async {
    _debugBox = await Hive.openBox(_debugSettingsBox);
    _showExerciseIncrementor = _debugBox.get(
      _showExerciseIncrementorKey,
      defaultValue: false,
    );
    notifyListeners();
  }

  void toggleShowExerciseIncrementor() {
    _showExerciseIncrementor = !_showExerciseIncrementor;
    _debugBox.put(_showExerciseIncrementorKey, _showExerciseIncrementor);
    notifyListeners();
  }
}
