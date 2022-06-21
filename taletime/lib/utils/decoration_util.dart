import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/welcome.dart';
import 'package:taletime/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'authentification_util.dart';

class Decorations {
  final FirebaseAuth auth = FirebaseAuth.instance;

  InputDecoration textInputDecoration(
      [String label = "",
      String hintText = "",
      Widget icon = const Icon(Icons.add, color: Colors.teal,),
      suffix,
      obscureText = false]) {
    return InputDecoration(
      labelText: label,
      focusColor: kPrimaryColor,
      hintText: hintText,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: kPrimaryColor)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: kPrimaryColor)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0)),
      prefixIcon: icon,
      suffix: suffix,
      labelStyle: TextStyle(
        color: kPrimaryColor,
      ),
    );
  }

  AppBar appBarDecoration(
      {required String? title, required BuildContext context}) {
    AppBar appBar = AppBar(
      elevation: 0,
      title: Text(title!),
      backgroundColor: kPrimaryColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
    return appBar;
  }

  BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 5),
      )
    ]);
  }

  BoxDecoration buttonBoxDecoration(BuildContext context,
      [String color1 = "", String color2 = ""]) {
    Color c1 = Theme.of(context).primaryColor;
    Color c2 = Theme.of(context).colorScheme.secondary;
    if (color1.isEmpty == false) {
      c1 = color1 as Color;
    }
    if (color2.isEmpty == false) {
      c2 = color2 as Color;
    }

    return BoxDecoration(
      boxShadow: const [
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 1.0],
        colors: [
          c1,
          c2,
        ],
      ),
      color: Colors.deepPurple.shade300,
      borderRadius: BorderRadius.circular(30),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      minimumSize: MaterialStateProperty.all(const Size(50, 50)),
      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
    );
  }

  AlertDialog alartDialog(String title, String content, BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: kPrimaryColor),
      ),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.ok,
            style: const TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  AlertDialog confirmDialog(
      String title, String content, BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: kPrimaryColor),
      ),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.yes,
            style: const TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              AuthentificationUtil(auth: auth).signOut();
              return const WelcomePage();
            }));
          },
        ),
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.no,
            style: const TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
