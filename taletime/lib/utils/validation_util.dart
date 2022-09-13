import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Hilfsklasse, die nützliche Methoden zur Validierung von Email, Passwort und Benutzernamen enthält

class ValidationUtil {
  /// Überprüft, ob die eingegebene Email-Adresse gültig ist
  ///
  /// [email] darf nicht leer sein und muss eine gültige Email-Adresse sein
  /// Wenn dies nicht der Fall ist wird ein String mit der zugehörigen Fehlermeldung zurückgegeben
  /// Wenn die [email] gültig ist wird null zurückgegeben
  String? validateEmail(String? email, BuildContext context) {
    if (email == null || email.isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }

    if (!EmailValidator.validate(email)) {
      return AppLocalizations.of(context)!.enterValidEmail;
    }
    return null;
  }

  /// Überprüft, ob das eingegebene Passwort gültig ist
  ///
  /// [password] darf nicht leer sein und muss mindestens 6 Zeichen lang sein
  /// Wenn dies nicht der Fall ist wird ein String mit der zugehörigen Fehlermeldung zurückgegeben
  /// Wenn das [password] gültig ist wird null zurückgegeben
  String? validatePassword(String? password, BuildContext context) {
    if (password == null || password.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }

    if (password.length < 6) {
      return AppLocalizations.of(context)!.passwordLength;
    }
    return null;
  }

  /// Überprüft, ob der eingegebene Benutzername gültig ist
  ///
  /// [username] darf nicht leer sein und muss mindestens 6 Zeichen lang sein
  /// Wenn dies nicht der Fall ist wird ein String mit der zugehörigen Fehlermeldung zurückgegeben
  /// Wenn der [username] gültig ist wird null zurückgegeben
  String? validateUserName(String? username, BuildContext context) {
    if (username == null || username.isEmpty) {
      return AppLocalizations.of(context)!.usernameRequired;
    }

    if (username.length < 6) {
      return AppLocalizations.of(context)!.usernameLength;
    }
    return null;
  }

  String? validateTitle(String? title, BuildContext context) {
    if (title == null || title.isEmpty) {
      return AppLocalizations.of(context)!.titleRequired;
    }

    if (title.length < 3) {
      return AppLocalizations.of(context)!.titleLength;
    }
    return null;
  }
}
