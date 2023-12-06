import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/common/models/story.dart";
import "package:taletime/common/widgets/story_list_item.dart";
import "package:taletime/common/widgets/tale_time_alert_dialog.dart";

import "../../common utils/tale_time_logger.dart";
import "../../internationalization/localizations_ext.dart";
import "listener_taletime_page.dart";

class AddStory extends StatefulWidget {
  final CollectionReference<AddedStory> storiesCollectionReference;
  final CollectionReference<Story> allStoriesCollectionReference;

  const AddStory(
      this.storiesCollectionReference, this.allStoriesCollectionReference,
      {super.key});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  List matchStoryList = [];
  Stream<QuerySnapshot<AddedStory>>? addedStoriesStream;
  Stream<QuerySnapshot<Story>>? allStoriesStream;
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
    allStoriesStream = widget.allStoriesCollectionReference
        .withConverter(
          fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
          toFirestore: (snap, _) => snap.toFirebase(),
        )
        .snapshots();
  }

  /*Future<void> updateStoryList(String storyId) {
    return widget.storiesCollectionReference
        .doc(storyId)
        .update({"id": storyId})
        .then((value) => logger.v("List Updated"))
        .catchError((error) => logger.e("Failed to update List: $error"));
  }*/

  Future<void> addStory(Story story) async {
    await widget.storiesCollectionReference
        .doc()
        .set(AddedStory.fromStory(
          story,
          liked: false,
          timeLastListened: 0,
        ))
        .then((value) {
      logger.v("Story Added to story list");
      setState(() {
        updateForce = true;
      });
    }).catchError(
            (error) => logger.e("Failed to add story to story list: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: addedStoriesStream,
      builder: (ctx, snapshotAddedStories) {
        final addedStories = snapshotAddedStories.data;
        return StreamBuilder(
          stream: allStoriesStream,
          builder: (ctx, snapshotAllStories) {
            final allStories = snapshotAllStories.data;
            if (addedStories == null || allStories == null) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final addedStoriesDocs = addedStories.docs;
            final allStoriesDocs = allStories.docs;

            var res = allStoriesDocs.where((story) {
              var isContained = false;
              for (var addedStory in addedStoriesDocs) {
                if (addedStory.id == story.id) {
                  isContained = true;
                  break;
                }
              }
              return !isContained;
            }).toList();
            return ListenerTaletimePage(
              docs: res,
              buttonsBuilder: (story) => [
                StoryActionButton(
                    icon: Icons.playlist_add_outlined,
                    onTap: () => {
                          showDialog(
                              context: context,
                              builder: (ctx) => TaleTimeAlertDialog(
                                      title: AppLocalizations.of(ctx)!
                                          .addStoryHint,
                                      content: AppLocalizations.of(ctx)!
                                          .addStoryHintDescription,
                                      buttons: [
                                        AlertDialogButton(
                                            text: AppLocalizations.of(ctx)!.yes,
                                            onPressed: () => {
                                                  addStory(story.data()),
                                                  Navigator.pop(context)
                                                }),
                                        AlertDialogButton(
                                            text: AppLocalizations.of(ctx)!.no,
                                            onPressed: () =>
                                                {Navigator.pop(context)})
                                      ]))
                        })
              ],
            );
          },
        );
      },
    );
  }
}
