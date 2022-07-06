import 'package:flutter/material.dart';

/// Klasse für die Internationaliserung der App
/// 
/// [supportedlanguages] enthält alle unterstützten Sprachen
/// [getCountryFlag] gibt den zugehörigen Ländercode aus
///

class L10n {
  static final supportedLanguages = [
    const Locale('de'),
    const Locale('en'),
    const Locale('ar')
  ];

  static String getCountryFlag(String code) {
    switch (code) {
      case 'de':
        return '🇩🇪';
      case 'ar':
        return '🇦🇪';
      case 'en':
        return '🇺🇸';
      default:
        return '🇺🇸';
    }
  }
}
