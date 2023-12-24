import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/common/models/story.dart";
import "package:taletime/common/widgets/story_list_item.dart";
import "package:taletime/common/widgets/tale_time_alert_dialog.dart";
import "package:taletime/state/profile_state.dart";

import "../../common utils/tale_time_logger.dart";
import "../../internationalization/localizations_ext.dart";
import "listener_taletime_page.dart";

class AddStory extends StatefulWidget {

  final CollectionReference<Story> allStoriesCollectionReference;

  const AddStory(
      this.allStoriesCollectionReference,
      {super.key});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  List matchStoryList = [];
  Stream<QuerySnapshot<Story>>? allStoriesStream;
  final logger = TaleTimeLogger.getLogger();

  _AddStoryState();

  void showConfirmDialog(QueryDocumentSnapshot<Story> story, BuildContext ctx, CollectionReference<AddedStory> addedStories) {
    var dialog = TaleTimeAlertDialog(
        title: AppLocalizations.of(ctx)!.addStoryHint,
        content: AppLocalizations.of(ctx)!.addStoryHintDescription,
        buttons: [
          AlertDialogButton(
              text: AppLocalizations.of(ctx)!.yes,
              onPressed: () =>
                  {addStory(story.data(), addedStories), Navigator.pop(context)}),
          AlertDialogButton(
              text: AppLocalizations.of(ctx)!.no,
              onPressed: () => {Navigator.pop(context)})
        ]);
    showDialog(context: context, builder: (ctx) => dialog);
  }

  @override
  void initState() {
    super.initState();

    allStoriesStream = widget.allStoriesCollectionReference
        .withConverter(
          fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
          toFirestore: (snap, _) => snap.toFirebase(),
        )
        .snapshots();
  }

  Future<void> addStory(Story story, CollectionReference<AddedStory> addedStories) async {
    var storyToAdd = AddedStory.fromStory(
      story,
      liked: false,
      timeLastListened: 0,
    );
    await addedStories
        .doc(storyToAdd.id)
        .set(storyToAdd)
        .then((value) {
      logger.v("Story Added to story list");
    }).catchError(
            (error) => logger.e("Failed to add story to story list: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileState>(
      builder: (context, profileState, _) => StreamBuilder(
        stream: profileState.storiesRef!.snapshots(),
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

              return Consumer<ProfileState>(
                builder: (context, profileState, _) => ListenerTaletimePage(
                  docs: res,
                  buttonsBuilder: (story) => [
                    StoryActionButton(
                        icon: Icons.playlist_add_outlined,
                        onTap: () => {showConfirmDialog(story, context, profileState.storiesRef!)})
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
