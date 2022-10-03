import 'package:flutter/material.dart';

/// Main color of the App
Color kPrimaryColor = Colors.teal.shade600;

/// Color used for showing errors
Color kErrorColor = const Color.fromARGB(255, 143, 0, 0);

/// Logo of the App (uploaded to Firebase Storage)
const String assetLogo =
    "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Flogo.png?alt=media&token=9a8874dd-766f-4ed0-827e-ca908e73207d";

/// Default Picture for newly created Stories if the user doesn't choose a Picture
const String storyImagePlaceholder =
    "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2FnoImage.jpg?alt=media&token=0e66dbf6-cd04-45bc-a79c-9ce4b46e5a60";

/// Images for the profiles that are used in the App
const List profileImages = [
  "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Fprofile_boy_01.png?alt=media&token=190fe16b-41b7-4957-8bbd-1a63dd0efdd7",
  "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Fprofile_boy_02.png?alt=media&token=866ef82a-9e8c-4def-989c-f1b843d777d3",
  "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Fprofile_girl_02.png?alt=media&token=db5cc965-8493-4cf2-86b9-8cf4a12ef0cf",
  "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Fprofile_girl_01.png?alt=media&token=bdd1b80c-7df2-49c5-bbd5-344c4af9379d",
  "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Fprofile_standard.png?alt=media&token=a5af1ee4-3d77-4354-9db3-4413e6234f7e"
];

/// Sets the Text-Color of an Elevated Button to white and the Button-Color to [kPrimaryColor]
ButtonStyle elevatedButtonDefaultStyle() {
  return ElevatedButton.styleFrom(
      primary: kPrimaryColor, onPrimary: Colors.white);
}

/// Prints the Duration of a recording or play of a story in the format 00:00
String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}