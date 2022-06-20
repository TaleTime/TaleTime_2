import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/login.dart';
import 'package:taletime/screens/profiles_page.dart';
import 'package:taletime/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/utils/error_util.dart';

/// author: Gianluca Goebel
/// Hilfsmethoden für die Authentifizierung mit Firebase

class AuthentificationUtil {
  final FirebaseAuth auth; //= FirebaseAuth.instance;

  AuthentificationUtil({required this.auth});

  User? get user => auth.currentUser;

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

    //await _auth.sendPasswordResetEmail(email: email);
  }

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
