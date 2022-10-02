import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/common%20utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// contains error-outputs in the form of a SnackBar for the LoginPage, the SignupPage and ResetPasswordPage
class ErrorUtil {
  /// Outputs the LoginPage errors in the form of a SnackBar
  SnackBar showLoginError(FirebaseAuthException e, BuildContext context) {
    final SnackBar snackBar;
    if (e.code == 'user-not-found') {
      snackBar = SnackBar(
          content: Text(AppLocalizations.of(context)!.userNotFound),
          backgroundColor: kErrorColor);
    } else if (e.code == 'wrong-password') {
      snackBar = SnackBar(
          content: Text(AppLocalizations.of(context)!.wrongPassword),
          backgroundColor: kErrorColor);
    } else {
      snackBar = const SnackBar(content: Text("null"));
    }
    return snackBar;
  }

  /// Outputs the SignupPage errors in the form of a SnackBar
  SnackBar showRegisterError(FirebaseAuthException e, BuildContext context) {
    final SnackBar snackBar;
    if (e.code == 'email-already-in-use') {
      snackBar = SnackBar(
          content: Text(AppLocalizations.of(context)!.emailAlreadyInUse),
          backgroundColor: kErrorColor);
    } else {
      snackBar = const SnackBar(content: Text("null"));
    }
    return snackBar;
  }

  /// Outputs the ForgotPasswordPage errors in the form of a SnackBar
  SnackBar showResetPasswordError(FirebaseException e, BuildContext context) {
    final SnackBar snackbar;
    if (e.code == 'user-not-found') {
      snackbar = SnackBar(
          content: Text(AppLocalizations.of(context)!.userNotFound),
          backgroundColor: kErrorColor);
    } else {
      snackbar = const SnackBar(content: Text("null"));
    }
    return snackbar;
  }
}
