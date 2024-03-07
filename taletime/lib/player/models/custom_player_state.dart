import "../../common/models/story.dart";

class CustomPlayerState {
  CustomPlayerState();
  final List<Story> storyPlaylist = [];
  int currentStoryPlayed = 0;

  bool hasPrev() {
    return currentStoryPlayed > 0;
  }

  bool hasNext() {
    return currentStoryPlayed < storyPlaylist.length - 1;
  }

  void setPlaylist(List<Story> stories) {
    storyPlaylist.clear();
    storyPlaylist.addAll(stories);
  }
}
