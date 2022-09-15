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
      Widget icon = const Icon(
        Icons.add,
        color: Colors.teal,
      ),
      Widget? suffix,
      obscureText = false]) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide()),
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
    );
  }

  AppBar appBarDecoration(
      {required String? title, required BuildContext context}) {
    AppBar appBar = AppBar(
      elevation: 0,
      title: Text(title!),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
        ),
      ),
    );
    return appBar;
  }

  BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.white.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 5),
      )
    ]);
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

  Container noRecentContent(String text, String view) {
    if (view == "recentStories") {
      return Container(
          padding: const EdgeInsets.only(left: 160, right: 100),
          margin: const EdgeInsets.only(top: 50),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ));
    }
    return Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
        margin: const EdgeInsets.only(top: 70),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ));
  }

  AlertDialog alertDialog(String title, String content, BuildContext context) {
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
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.yes,
          ),
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
          ),
          style: ButtonStyle(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
