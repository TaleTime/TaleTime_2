import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/login%20and%20registration/screens/login.dart";
import "package:taletime/profiles/screens/profiles_page.dart";
import "package:taletime/common%20utils/constants.dart";
import "../../internationalization/localizations_ext.dart";
import "package:taletime/login%20and%20registration/utils/error_util.dart";

/// Contains methods to authenticate with Firebase
class AuthentificationUtil {
  final logger = TaleTimeLogger.getLogger();
  final FirebaseAuth auth;

  AuthentificationUtil({required this.auth});

  /// returns the current user
  User? get user => auth.currentUser;

  /// Allows the login by entering email and password.
  ///
  /// catches all FirebaseAuthExceptions und outputs them in the form of a SnackBar as feedback for the user.
  ///
  /// if the login was successful then the user receives a confirmation that the registration was successful and redirects the user to the profile page.
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const ProfilesPage()));
      }
    } on FirebaseAuthException catch (e) {
      final SnackBar snackBar = ErrorUtil().showLoginError(e, context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// Allows the registration by entering email and password.
  ///
  /// catches all FirebaseAuthExceptions and outputs them in the form of a snack bar as feedback for the user.
  ///
  /// if the registration was successful then the user receives a confirmation that the registration was successful and redirects the user to the profile page.
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

      Map<String, dynamic> userInfoMap = {
        "email": email,
        "password": password,
        "userName": userName,
        "UID": auth.currentUser!.uid,
      };

      if (user != null) {
        final SnackBar signupSuccesful = SnackBar(
            content: Text(AppLocalizations.of(context)!.signUpSuccesful),
            backgroundColor: kPrimaryColor);
        ScaffoldMessenger.of(context).showSnackBar(signupSuccesful);

        addUserInfoToDB(auth.currentUser!.uid, userInfoMap);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ProfilesPage()));
      }
    } on FirebaseAuthException catch (e) {
      final SnackBar snackBar = ErrorUtil().showRegisterError(e, context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<DocumentSnapshot> getUserFromDB(String userId) {
    return FirebaseFirestore.instance.collection("users").doc(userId).get();
  }

  /// Allows the user to reset his password by entering his email address.
  ///
  /// catches all FirebaseAuthExceptions and outputs them in the form of a snack bar as feedback for the user.
  ///
  /// if the email is valid and exists, then a password reset message will be sent to the entered [email] and the user will be redirected to the login page.
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

  /// Allows the user to change his [oldPassword] to a [newPassword]
  void changePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    String? email = user!.email;
    if (email == null) {
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: oldPassword,
      );
      user!.updatePassword(newPassword).then((_) {
        logger.d("Successfully changed password");
        Navigator.pop(context);
      }).catchError((error) {
        logger.e("Password can't be changed$error");
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        logger.w("No user found for that email.");
      } else if (e.code == "wrong-password") {
        logger.w("Wrong password provided for that user.");
      }
    }
  }

  /// Logs out the currently logged in user.
  Future signOut() async {
    try {
      logger.v("signing out");
      return await auth.signOut();
    } catch (error) {
      logger.e("Sign out error: $error");
      return null;
    }
  }
}
