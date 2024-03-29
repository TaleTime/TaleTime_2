import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";

/// This class is used to change the current ThemeMode
class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  /// checks if the current Theme-Mode is set to Darkmode
  bool get isDarkMode => themeMode == ThemeMode.dark;

  /// changes the current Theme-Mode
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

/// This class contains color schemes for a Light- and Darkmode
class MyThemes {
  /// Darkmode
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    hintColor: Colors.white,
    focusColor: Colors.grey,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      shadowColor: MaterialStateProperty.all<Color>(Colors.white),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    )),
    primaryColor: Colors.grey,
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(),
      ),
      fillColor: Colors.black,
      prefixIconColor: Colors.white,
      labelStyle: TextStyle(color: Colors.white),
    ),
    buttonTheme: const ButtonThemeData(
      minWidth: 200.0,
      textTheme: ButtonTextTheme.primary,
      hoverColor: Colors.grey,
    ),
    iconTheme: const IconThemeData(color: Colors.white, opacity: 0.8),
    appBarTheme: const AppBarTheme(color: Colors.black),
    primaryTextTheme: Typography().white,
    textTheme: Typography().white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey,
        hoverColor: kPrimaryColor),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(kPrimaryColor),
        overlayColor: MaterialStateProperty.all(
          Colors.grey.shade800,
        ),
      ),
    ),
    sliderTheme: SliderThemeData(thumbColor: kPrimaryColor),
    colorScheme: const ColorScheme.dark().copyWith(error: Colors.red),
  );

  /// Lightmode
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: kPrimaryColor,
    hintColor: kPrimaryColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shadowColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        prefixIconColor: kPrimaryColor,
        labelStyle: TextStyle(color: kPrimaryColor)),
    iconTheme: IconThemeData(color: kPrimaryColor, opacity: 0.8),
    appBarTheme: AppBarTheme(color: kPrimaryColor),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: kPrimaryColor,
        hoverColor: Colors.grey),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(kPrimaryColor),
        overlayColor: MaterialStateProperty.all(Colors.grey),
      ),
    ),
    sliderTheme: SliderThemeData(
      thumbColor: kPrimaryColor,
    ),
  );
}
