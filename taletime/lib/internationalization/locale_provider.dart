import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:taletime/internationalization/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale("de");

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.supportedLanguages.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }
}
