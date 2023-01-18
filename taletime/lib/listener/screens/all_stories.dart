import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/common%20utils/constants.dart';

import '../../common utils/decoration_util.dart';
import '../../storyteller/utils/list_view_story_teller.dart';

class AllStories extends StatefulWidget {
  final CollectionReference recordedStoriesCollection;
  final profile;
  final profiles;
  const AllStories(this.profile, this.profiles, this.recordedStoriesCollection,
      {Key? key})
      : super(key: key);

  @override
  State<AllStories> createState() => _AllStoriesState(
      this.profile, this.profiles, this.recordedStoriesCollection);
}

class _AllStoriesState extends State<AllStories> {
  final CollectionReference recordedStoriesCollection;
  final profile;
  final profiles;
  _AllStoriesState(this.profile, this.profiles, this.recordedStoriesCollection);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: recordedStoriesCollection.snapshots(),
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
                      "All Stories",
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
                      Container(
                        height: 800,
                        child: recordedStoriesDocumentSnapshot.length == 0
                            ? Decorations().noRecentContent(
                                AppLocalizations.of(context)!
                                    .allStories_noStoriesAvailableError,
                                "")
                            : ListViewStoryTeller(
                                recordedStoriesDocumentSnapshot,
                                recordedStoriesCollection,
                                profile,
                                profiles),
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
