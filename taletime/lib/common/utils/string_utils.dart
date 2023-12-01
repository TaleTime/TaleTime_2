class StringUtils {
  static String durationToString(Duration duration) {
    String string = "";
    if (duration.inHours > 0) {
      string += "${duration.inHours}:";
    }

    String minuteString =
        duration.inMinutes.remainder(60).toString().padLeft(2, "0");
    String secondString =
        duration.inSeconds.remainder(60).toString().padLeft(2, "0");
    string += "$minuteString:$secondString";

    return string;
  }
}
