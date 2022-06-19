import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('de'),
    const Locale('en'),
    const Locale('ar')
  ];

  static String getFlag(String code) {
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
