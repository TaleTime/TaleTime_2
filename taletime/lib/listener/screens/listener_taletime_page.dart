import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:taletime/listener/screens/ListenerActionButtons.dart";

import "../../common utils/constants.dart";
import "../../common/models/added_story.dart";
import "../../common/models/story.dart";
import "../../common/widgets/story_list_item.dart";
import "../../internationalization/localizations_ext.dart";
import "../utils/search_bar_util.dart";

class ListenerTaletimePage extends StatefulWidget {
  final CollectionReference storiesCollectionReference;
  final CollectionReference allStoriesCollectionReference;
  final ListenerActionButtons buttons;

  const ListenerTaletimePage(
      this.storiesCollectionReference, this.allStoriesCollectionReference,
      this.buttons,
      {super.key});


  @override
  State<ListenerTaletimePage> createState() => _ListenerTaletimePageState();

}

class _ListenerTaletimePageState extends State<ListenerTaletimePage> {
  List matchStoryList = [];
  Stream<QuerySnapshot<AddedStory>>? _storiesStream;
  Stream<QuerySnapshot<AddedStory>>? addedStoriesStream;

  @override
  void initState() {
    super.initState();
    _storiesStream = widget.allStoriesCollectionReference
        .withConverter(
      fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
      toFirestore: (snap, _) => snap.toFirebase(),
    )
        .snapshots();
    addedStoriesStream = widget.storiesCollectionReference
        .withConverter(
      fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
      toFirestore: (snap, _) => snap.toFirebase(),
    )
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _storiesStream,
      builder:
          (context, AsyncSnapshot<QuerySnapshot<Story>> streamSnapshot) {
        if (streamSnapshot.hasData) {
          List<Story> storiesDocumentSnapshot = streamSnapshot.data!.docs.map((e) => e.data()).toList();

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
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
                                  buttons: widget.buttons.build(context, storiesDocumentSnapshot[i]),
                                  story: storiesDocumentSnapshot[i],
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