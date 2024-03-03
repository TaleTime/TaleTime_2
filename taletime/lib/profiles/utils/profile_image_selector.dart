import "package:flutter/widgets.dart";

class ProfileImageSelector {
  static String profileassetdir = "assets/profile/";

  static Image selectFile(String url, [double? height]) {
    if (url.contains("profile_boy_02")) {
      return Image.asset("${profileassetdir}profile_boy_2.png", height: height);
    } else if (url.contains("profile_boy")) {
      return Image.asset("${profileassetdir}profile_boy.png", height: height);
    } else if (url.contains("profile_girl_02")) {
      return Image.asset("${profileassetdir}profile_girl.png", height: height);
    } else if (url.contains("profile_girl_01")) {
      return Image.asset("${profileassetdir}profile_girl_1.png",
          height: height);
    }
    return Image.asset("${profileassetdir}profile_standard.png",
        height: height);
  }
}
