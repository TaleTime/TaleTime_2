import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';

/// Hilfsklasse, die die Farbschema für einen Light-und Darkmode enthalten sowie eine Funktion, um diesen umzuschalten

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade900,
      hintColor: Colors.white,
      errorColor: Colors.red,
      focusColor: Colors.grey,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
        shadowColor: MaterialStateProperty.all<Color>(Colors.white),
        shape:
        MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
      )),
      primaryColor: Colors.grey,
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(borderSide: BorderSide()),
          fillColor: Colors.black,
          prefixIconColor: Colors.white,
          labelStyle: TextStyle(color: Colors.white)),
      buttonTheme: ButtonThemeData(
        minWidth: 200.0,
        textTheme: ButtonTextTheme.primary,
        hoverColor: Colors.grey,
      ),
      iconTheme: IconThemeData(color: Colors.white, opacity: 0.8),
      appBarTheme: AppBarTheme(color: Colors.black),
      primaryTextTheme: Typography().white,
      textTheme: Typography().white,
      colorScheme: ColorScheme.dark(),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey,
          hoverColor: kPrimaryColor),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(kPrimaryColor),
              overlayColor: MaterialStateProperty.all(Colors.grey.shade800))));

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      hintColor: kPrimaryColor,
      errorColor: Colors.red,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
            shadowColor: MaterialStateProperty.all<Color>(Colors.white),
            shape:
            MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
          )),
      primaryColor: kPrimaryColor,
      inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          prefixIconColor: kPrimaryColor,
          labelStyle: TextStyle(color: kPrimaryColor)),
      iconTheme: IconThemeData(color: kPrimaryColor, opacity: 0.8),
      appBarTheme: AppBarTheme(color: kPrimaryColor),
      colorScheme: ColorScheme.light(),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: kPrimaryColor,
          hoverColor: Colors.grey),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(kPrimaryColor),
              overlayColor: MaterialStateProperty.all(Colors.grey))));
}
