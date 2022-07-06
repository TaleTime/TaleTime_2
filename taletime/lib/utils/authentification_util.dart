import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/login.dart';
import 'package:taletime/screens/profiles_page.dart';
import 'package:taletime/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/utils/error_util.dart';

/// Hilfsmethoden für die Authentifizierung mit Firebase

class AuthentificationUtil {
  final FirebaseAuth auth;
  
  AuthentificationUtil({required this.auth});

  /// Gibt den aktuell eingeloggten Benutzer zurück
  User? get user => auth.currentUser;

  /// Ermöglicht das Anmelden mit Eingabe von Email und Passwort
  ///
  /// fängt alle FirebaseAuthExceptions ab und gibt diese in Form einer Snackbar als Rückmeldung für den Benutzer aus
  /// wenn die Anmeldung erfolgreich war, erhält der Benutzer die Rückmeldung, dass die Anmeldung erfolgreich war
  /// und leitet den Nutzer zur Seite mit den Profilen weiter
  Future<void> loginUsingEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      User? user;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
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
      final SnackBar snackBar = ErrorUtil().showLoginError(e, context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// Ermöglicht das Registrieren mit Eingabe von Email und Passwort
  ///
  /// fängt alle FirebaseAuthExceptions ab und gibt diese in Form einer Snackbar als Rückmeldung für den Benutzer aus
  /// wenn die Registrierung erfolgreich war, erhält der Benutzer die Rückmeldung, dass die Registrierung erfolgreich war
  /// und leitet den Nutzer zur Seite mit den Profilen weiter
  Future<void> registerWithEmailAndPassword(
      {required String userName,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userData = await auth.createUserWithEmailAndPassword(
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
      final SnackBar snackBar = ErrorUtil().showRegisterError(e, context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// Ermöglicht die Zurücksetzung des Passworts mit der Eingabe der Email-Adresse
  ///
  /// fängt alle FirebaseAuthExceptions ab und gibt diese in Form einer Snackbar als Rückmeldung für den Benutzer aus
  /// wenn die Email gültig ist und existiert, dann wird an die eingegebene [email] eine Nachricht zur Zurücksetzung des Passworts versendet
  ///  und der Nutzer wird zur Anmeldeseite weitergeleitet
  Future<void> resetPasswordWithEmail(
      {required String email, required BuildContext context}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      SnackBar resetSuccesful = SnackBar(
          content: Text(AppLocalizations.of(context)!.emailSent),
          backgroundColor: kPrimaryColor);
      ScaffoldMessenger.of(context).showSnackBar(resetSuccesful);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } on FirebaseAuthException catch (e) {
      SnackBar snackBar = ErrorUtil().showResetPasswordError(e, context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// meldet den aktuell eingeloggten Benutzer aus
  Future signOut() async {
    try {
      // ignore: avoid_print
      print("signing out");
      return await auth.signOut();
    } catch (error) {
      // ignore: avoid_print
      print(error.toString());
      return null;
    }
  }
}
