import "package:flutter/widgets.dart";

class ProfileImageSelector {
  static String profileassetdir = "assets/profile/";

  Image selectFile(String url, [double? height]) {
    if (url.contains("profile_boy_02")) {
      return Image.asset("${profileassetdir}profile_boy_2.png", height: height);
    } else if (url.contains("profile_boy")) {
      return Image.asset("${profileassetdir}profile_boy.png", height: height);
    } else if (url.contains("profile_girl")) {
      return Image.asset("${profileassetdir}profile_girl.png", height: height);
    }
    return Image.asset("${profileassetdir}profile_standard.png",
        height: height);
  }
}
