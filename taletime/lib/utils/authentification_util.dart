import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';

/// author: Gianluca Goebel
/// Hilfsmethoden für die Authentifizierung mit Firebase

class AuthentificationUtil {
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email-Adresse ist erforderlich.';
    }

    if (!EmailValidator.validate(email)) {
      return 'Geben Sie eine gültige Email-Adresse ein';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Passwort ist erforderlich.';
    }

    if (password.length < 6) {
      return 'Passwort muss mindestens 6 Zeichen lang sein';
    }
    return null;
  }

  String? validateUserName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Benutzername ist erforderlich';
    }

    if (name.length < 6) {
      return 'Benutzername muss mindestens 6 Zeichen lang sein';
    }
    return null;
  }

  Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    //try {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    user = userCredential.user;
    //} on FirebaseAuthException catch (e) {
    //  if (e.code == "user-not-found") {
    //    print("No User found for that email");
    //  }
    //}
    return user;
  }

  Future<User?> registerWithEmailPassword(
      {required String userName,
      required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    UserCredential userData = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = userData.user;
    user?.updateDisplayName(userName);
    return user;
  }

  // Gibt die Fehler der LoginPage in Form einer SnackBar aus
  SnackBar showLoginError(FirebaseAuthException e) {
    final SnackBar snackBar;

    if (e.code == 'user-not-found') {
      snackBar = SnackBar(
          content: const Text(
              "Es wurde kein Nutzer mit der eingegebenen Email gefunden."),
          backgroundColor: kErrorColor);
    } else if (e.code == 'wrong-password') {
      snackBar = SnackBar(
          content: const Text("Falsches Passwort."),
          backgroundColor: kErrorColor);
    } else {
      snackBar = const SnackBar(content: Text("null"));
    }
    return snackBar;
  }


  // Gibt die Fehler der SignupPage in Form einer SnackBar aus
  SnackBar showRegisterError(FirebaseAuthException e) {
    final SnackBar snackBar;

    if (e.code == 'email-already-in-use') {
      snackBar = SnackBar(
          content: const Text(
              "Es existiert bereits ein Nutzer mit der eingegebenen Email-Adresse."),
          backgroundColor: kErrorColor);
    } else {
      snackBar = const SnackBar(content: Text("null"));
    }
    return snackBar;
  }
}
