import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// author: Gianluca Goebel
/// Hilfsmethoden für die Authentifizierung mit Firebase

class AuthentificationUtil {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? validateEmail(String? email, BuildContext context) {
    if (email == null || email.isEmpty) {
      return  AppLocalizations.of(context)!.emailRequired;
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

  Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    User? user;
    //try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    user = userCredential.user;
    return user;
  }

  Future<User?> registerWithEmailPassword(
      {required String userName,
      required String email,
      required String password,
      required BuildContext context}) async {
    UserCredential userData = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = userData.user;
    user?.updateDisplayName(userName);
    return user;
  }

  Future<void> resetPasswordWithEmail(
      {required String email, required BuildContext context}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future signOut() async {
    try {
      // ignore: avoid_print
      print("signing out");
      return await _auth.signOut();
    } catch (error) {
      // ignore: avoid_print
      print(error.toString());
      return null;
    }
  }

  // Gibt die Fehler der LoginPage in Form einer SnackBar aus
  SnackBar showLoginError(FirebaseAuthException e, BuildContext context) {
    final SnackBar snackBar;

    if (e.code == 'user-not-found') {
      snackBar = SnackBar(
          content:  Text(
              AppLocalizations.of(context)!.userNotFound),
          backgroundColor: kErrorColor);
    } else if (e.code == 'wrong-password') {
      snackBar = SnackBar(
          content:  Text(AppLocalizations.of(context)!.wrongPassword),
          backgroundColor: kErrorColor);
    } else {
      snackBar = const SnackBar(content: Text("null"));
    }
    return snackBar;
  }

  // Gibt die Fehler der SignupPage in Form einer SnackBar aus
  SnackBar showRegisterError(FirebaseAuthException e, BuildContext context) {
    final SnackBar snackBar;

    if (e.code == 'email-already-in-use') {
      snackBar = SnackBar(
          content:  Text(
              AppLocalizations.of(context)!.emailAlreadyInUse),
          backgroundColor: kErrorColor);
    } else {
      snackBar = const SnackBar(content: Text("null"));
    }
    return snackBar;
  }

  // Gibt die Fehler der ForgotPasswordPage in Form einer SnackBar aus
  SnackBar showResetPasswordError(FirebaseException e, BuildContext context) {
    final SnackBar snackbar;

    if (e.code == 'user-not-found') {
      snackbar = SnackBar(
          content:  Text(
              AppLocalizations.of(context)!.userNotFound),
          backgroundColor: kErrorColor);
    } else {
      snackbar = const SnackBar(content: Text("null"));
    }
    return snackbar;
  }
}
