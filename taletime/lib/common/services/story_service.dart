import "package:cloud_firestore/cloud_firestore.dart";
import "package:taletime/common/models/added_story.dart";

class StoryService {
  /// Changes the status wheather a story is liked or not.
  static void LikeStory(DocumentReference<AddedStory> story, bool liked) {
    story.update({"isLiked": liked});
  }
}
