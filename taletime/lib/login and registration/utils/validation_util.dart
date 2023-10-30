import "package:email_validator/email_validator.dart";
import "package:flutter/material.dart";

import "../../internationalization/localizations_ext.dart";

/// This class has methods to validate email, password, username and a title
class ValidationUtil {
  /// Checks if the entered [email] is valid.
  ///
  /// [email] can't be empty and must be a valid email-adress.
  ///
  /// If this isn't the case then a String with the belonging error message is returned.
  ///
  /// If the [email] is valid then null is returned.
  String? validateEmail(String? email, BuildContext context) {
    if (email == null || email.isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }

    if (!EmailValidator.validate(email)) {
      return AppLocalizations.of(context)!.enterValidEmail;
    }
    return null;
  }

  /// Checks if the entered [password] is valid.
  ///
  /// [password] can't be empty and must be at least 6 characters long.
  ///
  /// If this isn't the case then a String with the belonging error message is returned.
  ///
  /// If the [password] is valid then null is returned.
  String? validatePassword(String? password, BuildContext context) {
    if (password == null || password.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }

    if (password.length < 6) {
      return AppLocalizations.of(context)!.passwordLength;
    }
    return null;
  }

  /// Checks if the entered [passwordConfirmation] is valid.
  ///
  /// [passwordConfirmation] can't be empty and must match [password].
  ///
  /// If this isn't the case then a String with the belonging error message is returned.
  ///
  /// If the [password] is valid then null is returned.
  String? validatePasswordConfirmation(
      String? passwordConfirmation, String? password, BuildContext context) {

    if (passwordConfirmation == null || passwordConfirmation.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }

    if (passwordConfirmation.trim() != password) {
      return AppLocalizations.of(context)!.passwordsDontMatch;
    } else {
      return ValidationUtil().validatePassword(passwordConfirmation, context);
    }
  }

  /// Checks if the entered [username] is valid
  ///
  /// [username] can't be empty and must be at least 6 characters long.
  ///
  /// If this isn't the case then a String with the belonging error message is returned.
  ///
  /// If the [username] is valid then null is returned.
  String? validateUserName(String? username, BuildContext context) {
    if (username == null || username.isEmpty) {
      return AppLocalizations.of(context)!.usernameRequired;
    }

    if (username.length < 6) {
      return AppLocalizations.of(context)!.usernameLength;
    }
    return null;
  }

  /// Checks if the entered [title] is valid
  ///
  /// [title] can't be empty and must be at least 3 characters long.
  ///
  /// If this isn't the case then a String with the belonging error message is returned.
  ///
  /// If the [title] is valid then null is returned.
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
