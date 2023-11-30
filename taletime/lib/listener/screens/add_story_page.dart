import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/common/widgets/story_list_item.dart";
import "package:taletime/common/widgets/tale_time_alert_dialog.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "../../common utils/constants.dart";
import "../../common utils/tale_time_logger.dart";
import "../utils/icon_context_dialog.dart";
import "../utils/search_bar_util.dart";

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
  Stream<QuerySnapshot<AddedStory>>? _storiesStream;
  final logger = TaleTimeLogger.getLogger();

  _AddStoryState();

  @override
  void initState() {
    super.initState();
    _storiesStream = widget.allStoriesCollectionReference
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _storiesStream,
      builder:
          (context, AsyncSnapshot<QuerySnapshot<AddedStory>> streamSnapshot) {
        if (streamSnapshot.hasData) {
          final List<QueryDocumentSnapshot<AddedStory>>
              storiesDocumentSnapshot = streamSnapshot.data!.docs;
          return Scaffold(
              appBar: AppBar(
                leading: null,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                toolbarOpacity: 0,
                title: Text(
                  AppLocalizations.of(context)!.addStory,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      size: 23,
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 42,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            matchStoryList = SearchBarUtil()
                                .searchStory(storiesDocumentSnapshot, value);
                          });
                          SearchBarUtil()
                              .isStoryListEmpty(matchStoryList, value);
                        },
                        style: TextStyle(color: kPrimaryColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 30),
                          filled: true,
                          fillColor: Colors.blueGrey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          hintText: AppLocalizations.of(context)!.searchStory,
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 18),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        primary: false,
                        padding: const EdgeInsets.all(8),
                        itemCount: storiesDocumentSnapshot.length,
                        itemBuilder: (k, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                StoryListItem(
                                  buttons: [
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
                                                            AlertDialogButton(text: AppLocalizations.of(ctx)!.yes, onPressed: ()=>{}),
                                                            AlertDialogButton(text: AppLocalizations.of(ctx)!.no, onPressed: ()=>{})
                                                          ]))
                                            })
                                  ],
                                  story: storiesDocumentSnapshot[i].data(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
