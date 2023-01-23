import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/common%20utils/constants.dart';
import '../internationalization/localizations_ext.dart';

class Decorations {
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Decoration for a TextField
  ///
  /// [label] --> Label of the TextField
  ///
  /// [hintText] --> Hint-Text of the TextField
  ///
  /// [icon] --> Icon that is on the Left of the TextField
  ///
  /// [suffix] --> Icon or Button that is on the right of the TextField
  ///
  /// [obscureText] --> If true then the entered Text is not visible
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

  /// decoration for the AppBar
  ///
  /// [title] --> Title of the AppBar
  ///
  /// if [automaticArrow] is true then there will be a IconButton to return to the last page
  AppBar appBarDecoration(
      {required String? title,
      required BuildContext context,
      required bool automaticArrow}) {
    AppBar appBar = AppBar(
        elevation: 0,
        automaticallyImplyLeading: automaticArrow,
        title: Text(title!),
        leading: automaticArrow
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
              )
            : null);
    return appBar;
  }

  /// shadow for BoxDecoration
  BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.white.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 5),
      )
    ]);
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

  /// AlertDialog that aks for confirmation for a specific Function [onTap]
  ///
  /// [title] --> Title of the AlertDialog
  ///
  /// [content] --> Content of the AlertDialog
  ///
  /// [onTap] --> Function that gets called if the user confirms the AlertDialog
  AlertDialog confirmationDialog(
      String title, String content, BuildContext context, Function onTap) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.yes,
          ),
          onPressed: () {
            onTap();
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
