import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "../../common/models/story.dart";
import "../../internationalization/localizations_ext.dart";
import "package:taletime/common%20utils/constants.dart";
import "../../common utils/decoration_util.dart";
import "../utils/list_view_story_teller.dart";

class AllStories extends StatefulWidget {
  final CollectionReference<Story> recordedStoriesCollection;

  const AllStories(this.recordedStoriesCollection, {super.key});

  @override
  State<AllStories> createState() => _AllStoriesState();
}

class _AllStoriesState extends State<AllStories> {
  _AllStoriesState();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.recordedStoriesCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<QueryDocumentSnapshot> recordedStoriesDocumentSnapshot =
                streamSnapshot.data!.docs;
            return Scaffold(
                body: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 8,
                  right: 16,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    title: Text(
                      AppLocalizations.of(context)!.allStories_pageTitle,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 23,
                        color: kPrimaryColor,
                      ),
                    ),
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
                ),
                Positioned(
                  top: 85,
                  left: 15,
                  right: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 800,
                        child: recordedStoriesDocumentSnapshot.isEmpty
                            ? Decorations().noRecentContent(
                                AppLocalizations.of(context)!
                                    .allStories_noStoriesAvailableError,
                                "")
                            : ListViewStoryTeller(
                                recordedStoriesDocumentSnapshot,
                                widget.recordedStoriesCollection,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          }
        });
  }
}
