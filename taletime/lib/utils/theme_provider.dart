import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

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
          style: ElevatedButton.styleFrom(
        primary: kPrimaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
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
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black))));


  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      hintColor: kPrimaryColor,
      errorColor: Colors.red,
      //focusColor: kPrimaryColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              textStyle: TextStyle(color: kPrimaryColor))),
      primaryColor: kPrimaryColor,
      inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          prefixIconColor: kPrimaryColor,
          labelStyle: TextStyle(color: kPrimaryColor)),
      iconTheme: IconThemeData(color: kPrimaryColor, opacity: 0.8),
      appBarTheme: AppBarTheme(color: kPrimaryColor),
      colorScheme: ColorScheme.light(),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black)))
      
      );
}
