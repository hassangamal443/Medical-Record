import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      _locale = Locale(languageCode);
    }
    notifyListeners(); // Ensure listeners are notified after setting the locale
  }


  Future<void> setLocale(Locale locale) async {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners(); // Ensure listeners are notified after setting the locale
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }
}

class L10n {
  static final all = [
    Locale('en'),
    Locale('ar'),
  ];
}
