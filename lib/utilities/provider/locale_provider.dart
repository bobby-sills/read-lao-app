import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'locale';
  late Box _settingsBox;
  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  bool get isLao => _locale.languageCode == 'lo';

  LocaleProvider() {
    _loadLocale();
  }

  void _loadLocale() async {
    _settingsBox = await Hive.openBox('settings');
    final saved = _settingsBox.get(_localeKey) as String?;
    if (saved != null) {
      _locale = Locale(saved);
    } else {
      // Default to device locale if supported, otherwise English
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      _locale = deviceLocale.languageCode == 'lo'
          ? const Locale('lo')
          : const Locale('en');
    }
    notifyListeners();
  }

  void toggleLocale() {
    _locale = isLao ? const Locale('en') : const Locale('lo');
    _settingsBox.put(_localeKey, _locale.languageCode);
    notifyListeners();
  }
}
