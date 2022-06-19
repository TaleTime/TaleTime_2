import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/login.dart';
import 'package:taletime/screens/profiles_page.dart';
import 'package:taletime/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// author: Gianluca Goebel
/// Hilfsmethoden für die Authentifizierung mit Firebase

class AuthentificationUtil {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      User? user;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      if (user != null) {
        final SnackBar signinSuccesful = SnackBar(
            content: Text(AppLocalizations.of(context)!.signInSuccesful),
            backgroundColor: kPrimaryColor);
        ScaffoldMessenger.of(context).showSnackBar(signinSuccesful);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfilesPage()));
      }
    } on FirebaseAuthException catch (e) {
      final SnackBar snackBar =
          AuthentificationUtil().showLoginError(e, context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> registerWithEmailPassword(
      {required String userName,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userData = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userData.user;
      user?.updateDisplayName(userName);
      if (user != null) {
        final SnackBar signupSuccesful = SnackBar(
            content: Text(AppLocalizations.of(context)!.signUpSuccesful),
            backgroundColor: kPrimaryColor);
        ScaffoldMessenger.of(context).showSnackBar(signupSuccesful);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfilesPage()));
      }
    } on FirebaseAuthException catch (e) {
      final SnackBar snackBar =
          AuthentificationUtil().showRegisterError(e, context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> resetPasswordWithEmail(
      {required String email, required BuildContext context}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      SnackBar resetSuccesful = SnackBar(
          content: Text(AppLocalizations.of(context)!.emailSent),
          backgroundColor: kPrimaryColor);
      ScaffoldMessenger.of(context).showSnackBar(resetSuccesful);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } on FirebaseAuthException catch (e) {
      SnackBar snackBar =
          AuthentificationUtil().showResetPasswordError(e, context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    //await _auth.sendPasswordResetEmail(email: email);
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

  // Gibt die Fehler der SignupPage in Form einer SnackBar aus
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

  // Gibt die Fehler der ForgotPasswordPage in Form einer SnackBar aus
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
