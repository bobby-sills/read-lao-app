import 'package:flutter/foundation.dart';

class LessonProvider with ChangeNotifier {
  VoidCallback? nextExercise;
  VoidCallback? markExerciseAsMistake;

  bool _isBottomSheetVisible = false;
  set isBottomSheetVisible(bool isVisible) {
    _isBottomSheetVisible = isVisible;
    notifyListeners();
  }

  bool get isBottomSheetVisible => _isBottomSheetVisible;

  void setBottomSheetVisible(bool isVisible) {
    _isBottomSheetVisible = isVisible;
    notifyListeners();
  }
}
