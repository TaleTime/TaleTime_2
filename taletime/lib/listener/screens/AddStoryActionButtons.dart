import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/listener/screens/ListenerActionButtons.dart";

import "../../common utils/tale_time_logger.dart";
import "../../common/models/story.dart";
import "../../common/widgets/story_list_item.dart";
import "../../common/widgets/tale_time_alert_dialog.dart";
import "../../internationalization/localizations_ext.dart";

class AddStoryActionButtons extends ListenerActionButtons{
  final CollectionReference storiesCollectionReference;
  final logger = TaleTimeLogger.getLogger();

  AddStoryActionButtons(this.storiesCollectionReference);

  Future<void> updateStoryList(String storyId) {
    return storiesCollectionReference
        .doc(storyId)
        .update({"id": storyId})
        .then((value) => logger.v("List Updated"))
        .catchError((error) => logger.e("Failed to update List: $error"));
  }

  Future<void> addStory(String audio, String author, String image, String title,
      String rating, bool isLiked) async {
    await storiesCollectionReference.add({
      "id": "",
      "image": image,
      "audio": audio,
      "title": title,
      "rating": rating,
      "author": author,
      "isLiked": isLiked
    }).then((value) {
      logger.v("Story Added to story list");
      updateStoryList(value.id);
    }).catchError(
            (error) => logger.e("Failed to add story to story list: $error"));
  }

  @override
  List<StoryActionButton> build(BuildContext context, Story story) {
    return [
          StoryActionButton(
              icon: Icons.playlist_add_outlined,
              onTap: () => {
                showDialog(
                    context: context,
                    builder: (ctx) =>
                        TaleTimeAlertDialog(
                            title:
                            AppLocalizations
                                .of(ctx)!
                                .addStoryHint,
                            content: AppLocalizations
                                .of(ctx)!
                                .addStoryHintDescription,
                            buttons: [
                              AlertDialogButton(text: AppLocalizations.of(ctx)!.yes, onPressed: ()=>{
                                addStory(story.audioUrl!, story.author!, story.imageUrl!, story.title!, story.rating!, false),
                                Navigator.pop(context)
                              }),
                              AlertDialogButton(text: AppLocalizations.of(ctx)!.no, onPressed: ()=>{
                                Navigator.pop(context)
                              })
                            ]))
              })
    ];
  }
}