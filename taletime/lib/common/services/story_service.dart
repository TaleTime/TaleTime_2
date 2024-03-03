import "package:cloud_firestore/cloud_firestore.dart";
import "package:taletime/common/models/added_story.dart";

class StoryService {
  /// Changes the status whether a story is liked or not.
  static void likeStory(DocumentReference<AddedStory> story, bool liked) {
    story.update({"isLiked": liked});
  }

  /// Deletes a story from the user's added stories
  static void deleteStory(DocumentReference<AddedStory> story) {
    story.delete();
  }
}
