import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/common/widgets/story_card.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "../../common utils/constants.dart";
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
  _AddStoryState();

  @override
  void initState() {
    super.initState();
    _storiesStream = widget.allStoriesCollectionReference
        .withConverter(
      fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
      toFirestore: (snap, _) => snap.toFirebase(),
    ).snapshots();
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
        stream: _storiesStream,
        builder: (context, AsyncSnapshot<QuerySnapshot<AddedStory>> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<QueryDocumentSnapshot<AddedStory>> storiesDocumentSnapshot = streamSnapshot.data!.docs;
            return Scaffold(
              body: Stack(children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
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
                Column(
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
                  ],
                ),
                Positioned(
                  top: 150,
                  left: 15,
                  right: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.8,
                        child: ListView.builder(
                          primary: false,
                          itemCount: storiesDocumentSnapshot.length,
                          itemBuilder: (k, i) {
                            return GestureDetector(
                              child: StoryCard(
                                story: storiesDocumentSnapshot[i].data(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
