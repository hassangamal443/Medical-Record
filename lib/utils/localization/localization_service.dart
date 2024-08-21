import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';

class LocalizationService {
  Map<String, dynamic>? localizedStrings;

  Future<void> loadLocalizedStrings(Locale locale) async {
    String jsonString = await rootBundle.loadString('path_to_your_json_file');
    localizedStrings = json.decode(jsonString);
  }

  String? getLocalizedString(String key) {
    return localizedStrings?[key];
  }
}
