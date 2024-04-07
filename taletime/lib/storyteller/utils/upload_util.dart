import "package:cloud_firestore/cloud_firestore.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";

import "../../common/models/story.dart";

class UploadUtil {
  final logger = TaleTimeLogger.getLogger();
  late final CollectionReference<Story>? storiesCollection;
  UploadUtil(this.storiesCollection);

  CollectionReference<Story> allStories =
      FirebaseFirestore.instance.collection("allStories").withConverter(
            fromFirestore: (snap, _) => Story.fromDocumentSnapshot(snap),
            toFirestore: (snap, _) => snap.toFirebase(),
          );
  Future<void> uploadStory(String audio, String author, String image,
      String title, String rating, bool isLiked) {
    var storyToAdd = Story(
      id: "",
      rating: rating,
      audioUrl: audio,
      imageUrl: image,
      author: author,
      title: title,
    );

    return allStories.add(storyToAdd).then<void>((value) {
      logger.d("Story uploaded succesfully");
      updateList(value.id);
    }).catchError((error) => logger.e("Failed to upload story: $error"));
  }

  Future<void> updateList(String storyId) {
    return allStories
        .doc(storyId)
        .update({"id": storyId})
        .then((value) => logger.v("List Updated"))
        .catchError((error) => logger.e("Failed to update List: $error"));
  }

  Future<void> deleteStory(String storyId) {
    return storiesCollection
            ?.doc(storyId)
            .delete()
            .then((value) => logger.v("story Deleted"))
            .catchError(
                (error) => logger.e("Failed to delete story: $error")) ??
        Future.value();
  }
}
