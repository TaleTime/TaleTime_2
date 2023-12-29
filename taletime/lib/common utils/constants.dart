import "package:flutter/material.dart";
import "package:taletime/profiles/models/profile_model.dart";

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
const List<String> profileImages = [
  "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Fprofile_boy_01.png?alt=media&token=190fe16b-41b7-4957-8bbd-1a63dd0efdd7",
  "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Fprofile_boy_02.png?alt=media&token=866ef82a-9e8c-4def-989c-f1b843d777d3",
  "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Fprofile_girl_02.png?alt=media&token=db5cc965-8493-4cf2-86b9-8cf4a12ef0cf",
  "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Fprofile_girl_01.png?alt=media&token=bdd1b80c-7df2-49c5-bbd5-344c4af9379d",
  "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Fprofile_standard.png?alt=media&token=a5af1ee4-3d77-4354-9db3-4413e6234f7e"
];

//Onboarding

const String welcomePage =
    "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2FwelcomePage.png?alt=media&token=6ad30c48-603f-4111-bfc8-0611302e6d65";

/// Sets the Text-Color of an Elevated Button to white and the Button-Color to [kPrimaryColor]
ButtonStyle elevatedButtonDefaultStyle() {
  return ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: kPrimaryColor);
}

/// Prints the Duration of a recording or play of a story in the format 00:00
String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}

//---------Animation Duration-----------

const animationDuration = Duration(milliseconds: 200);

//---------Onboarding------------
const background = Color.fromARGB(255, 255, 255, 255);
const footerPadding = EdgeInsets.only(left: 45.0, right: 45.0, bottom: 45.0);
const pageContentPadding = EdgeInsets.only(top: 45.0, left: 45.0, right: 45.0);
const pageTitleStyle = TextStyle(
  fontSize: 23.0,
  wordSpacing: 1,
  letterSpacing: 1.2,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
const pageInfoStyle = TextStyle(
  color: Colors.black,
  letterSpacing: 0.7,
  height: 1.5,
);
const titleAndInfoPadding = EdgeInsets.only(bottom: 45);

const arrows = Color.fromRGBO(0, 137, 123, 1);

var defaultProfile = Profile(
    id: "",
    image: profileImages[4],
    name: "",
    title: ProfileType.listener,
    language: "en",
    theme: false);
