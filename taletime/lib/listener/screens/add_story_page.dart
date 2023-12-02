import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/listener/screens/AddStoryActionButtons.dart";
import "package:taletime/listener/screens/ListenerActionButtons.dart";
import "../../common utils/tale_time_logger.dart";
import "../../common/widgets/story_list_item.dart";
import "../../common/widgets/tale_time_alert_dialog.dart";
import "../../internationalization/localizations_ext.dart";
import "../../profiles/models/profile_model.dart";
import "../../profiles/utils/profile_list.dart";
import "listener_taletime_page.dart";

class AddStory extends StatefulWidget {
  final CollectionReference storiesCollectionReference;
  final CollectionReference allStoriesCollectionReference;

  const AddStory(
      this.storiesCollectionReference, this.allStoriesCollectionReference,
      {super.key});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  List matchStoryList = [];
  Stream<QuerySnapshot<AddedStory>>? addedStoriesStream;
  final logger = TaleTimeLogger.getLogger();
  bool updateForce = false;

  _AddStoryState();

  @override
  void initState() {
    super.initState();
    addedStoriesStream = widget.storiesCollectionReference
        .withConverter(
      fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
      toFirestore: (snap, _) => snap.toFirebase(),
    )
        .snapshots();
  }


  Future<void> updateStoryList(String storyId) {
    return widget.storiesCollectionReference
        .doc(storyId)
        .update({"id": storyId})
        .then((value) => logger.v("List Updated"))
        .catchError((error) => logger.e("Failed to update List: $error"));
  }

  Future<void> addStory(String audio, String author, String image, String title,
      String rating, bool isLiked) async {
    await widget.storiesCollectionReference.add({
      "id": "",
      "image": image,
      "audio": audio,
      "title": title,
      "rating": rating,
      "author": author,
      "isLiked": isLiked
    })
        .then((value) {
      logger.v("Story Added to story list");
      updateStoryList(value.id);
      setState(() {
        updateForce = true;
      });
    }).catchError((error) =>
        logger.e("Failed to add story to story list: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return ListenerTaletimePage(
        widget.storiesCollectionReference,
        widget.allStoriesCollectionReference, AddStoryActionButtons(widget.storiesCollectionReference));
  }
}
