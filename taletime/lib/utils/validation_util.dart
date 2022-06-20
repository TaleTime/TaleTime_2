import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ValidationUtil {
  String? validateEmail(String? email, BuildContext context) {
    if (email == null || email.isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }

    if (!EmailValidator.validate(email)) {
      return AppLocalizations.of(context)!.enterValidEmail;
    }
    return null;
  }

  String? validatePassword(String? password, BuildContext context) {
    if (password == null || password.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }

    if (password.length < 6) {
      return AppLocalizations.of(context)!.passwordLength;
    }
    return null;
  }

  String? validateUserName(String? name, BuildContext context) {
    if (name == null || name.isEmpty) {
      return AppLocalizations.of(context)!.usernameRequired;
    }

    if (name.length < 6) {
      return AppLocalizations.of(context)!.usernameLength;
    }
    return null;
  }
}
