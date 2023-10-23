import "package:cloud_firestore/cloud_firestore.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";

class UploadUtil {
  final logger = TaleTimeLogger.getLogger();
  late final CollectionReference storiesCollection;
  UploadUtil(CollectionReference storiesCollection) {
    this.storiesCollection = storiesCollection;
  }

  CollectionReference allStories =
      FirebaseFirestore.instance.collection("allStories");
  Future<void> uploadStory(String audio, String author, String image,
      String title, String rating, bool isLiked) {
    return allStories.add({
      "id": "",
      "image": image,
      "audio": audio,
      "title": title,
      "rating": rating,
      "author": author,
      "isLiked": isLiked
    }).then((value) {
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
        .doc(storyId)
        .delete()
        .then((value) => logger.v("story Deleted"))
        .catchError((error) => logger.e("Failed to delete story: $error"));
  }
}
