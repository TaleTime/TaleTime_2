import 'package:cloud_firestore/cloud_firestore.dart';

class UploadUtil {
  late final CollectionReference storiesCollection;
  UploadUtil(CollectionReference storiesCollection) {
    this.storiesCollection = storiesCollection;
  }

  CollectionReference allStories =
      FirebaseFirestore.instance.collection('allStories');
  Future<void> uploadStory(String audio, String author, String image,
      String title, String rating, bool isLiked) {
    return allStories.add({
      'id': "",
      'image': image,
      'audio': audio,
      'title': title,
      'rating': rating,
      'author': author,
      'isLiked': isLiked
    }).then((value) {
      print("Story uploaded succesfully");
      updateList(value.id);
    }).catchError((error) => print("Failed to upload story: $error"));
  }

  Future<void> updateList(String storyId) {
    return allStories
        .doc(storyId)
        .update({'id': storyId})
        .then((value) => print("List Updated"))
        .catchError((error) => print("Failed to update List: $error"));
  }

  Future<void> deleteStory(String storyId) {
    return storiesCollection
        .doc(storyId)
        .delete()
        .then((value) => print("story Deleted"))
        .catchError((error) => print("Failed to delete story: $error"));
  }
}
