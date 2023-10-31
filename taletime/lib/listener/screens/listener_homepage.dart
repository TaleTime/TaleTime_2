import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:marquee/marquee.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/common/widgets/story_list_item.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/listener/screens/my_play_story.dart";
import "package:taletime/profiles/models/profile_model.dart";

import "../../common utils/decoration_util.dart";
import "../../settings/settings.dart";

class ListenerHomePage extends StatefulWidget {
  final Profile profile;
  final profiles;
  final CollectionReference favoritesCollection;
  final CollectionReference storiesCollection;
  final CollectionReference recentCollection;

  const ListenerHomePage(this.profile, this.profiles, this.storiesCollection,
      this.recentCollection, this.favoritesCollection,
      {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ListenerHomePageState();
  }
}

class _ListenerHomePageState extends State<ListenerHomePage> {
  _ListenerHomePageState();

  var _selectedIndex = 0;

  Stream<QuerySnapshot<AddedStory>>? _storiesStream;
  Stream<QuerySnapshot<AddedStory>>? _recentlyPlayedStoriesStream;

  @override
  void initState() {
    super.initState();

    _storiesStream = widget.storiesCollection
        .withConverter(
          fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
          toFirestore: (snap, _) => snap.toFirebase(),
        )
        .snapshots();

    _recentlyPlayedStoriesStream = widget.storiesCollection
        .withConverter(
          fromFirestore: (snap, _) => AddedStory.fromDocumentSnapshot(snap),
          toFirestore: (snap, _) => snap.toFirebase(),
        )
        .where("timeLastPlayed", isNotEqualTo: null)
        .orderBy("timeLastPlayed", descending: true)
        .limit(10)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: widget.storiesCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          final List<QueryDocumentSnapshot> storiesDocumentSnapshot =
              streamSnapshot.data!.docs;
          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 8,
                  right: 16,
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsPage(
                                      widget.profile, widget.profiles)));
                        },
                        icon: Icon(Icons.menu,
                            size: 33, color: kPrimaryColor //kPrimaryColor
                            ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 22,
                  right: 28,
                  height: screenHeight * 0.34,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.hello},",
                        style: TextStyle(
                            color: Colors.brown.shade600, fontSize: 15),
                      ),
                      Text(
                        widget.profile.name,
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 42,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {});
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
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 18),
                            suffixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          AppLocalizations.of(context)!.recentlyPlayed,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: _recentlyPlayedStoriesStream,
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        final List<QueryDocumentSnapshot> documentSnapshot =
                            streamSnapshot.data!.docs;
                        return Positioned(
                          top: 270,
                          left: -90,
                          right: 0,
                          child: documentSnapshot.isEmpty
                              ? Decorations().noRecentContent(
                                  AppLocalizations.of(context)!
                                      .noStoriesAvailable,
                                  "recentStories")
                              : SizedBox(
                                  height: 190,
                                  child: PageView.builder(
                                      onPageChanged: (index) {
                                        setState(() {
                                          _selectedIndex = index;
                                        });
                                      },
                                      controller:
                                          PageController(viewportFraction: 0.4),
                                      itemCount: documentSnapshot == null
                                          ? 0
                                          : documentSnapshot.length,
                                      itemBuilder: (_, i) {
                                        var scale =
                                            _selectedIndex == i ? 1.0 : 0.8;
                                        return TweenAnimationBuilder(
                                            duration: const Duration(
                                                microseconds: 350),
                                            tween:
                                                Tween(begin: scale, end: scale),
                                            curve: Curves.ease,
                                            child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return MyPlayStory(
                                                        documentSnapshot[i],
                                                        widget
                                                            .storiesCollection);
                                                  }));
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 30),
                                                  height: 180,
                                                  width: 85,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15,
                                                          left: 15,
                                                          right: 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            documentSnapshot[i][
                                                                        "image"] ==
                                                                    ""
                                                                ? storyImagePlaceholder
                                                                : documentSnapshot[
                                                                        i]
                                                                    ["image"]),
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.6),
                                                                BlendMode
                                                                    .dstATop),
                                                        fit: BoxFit.cover,
                                                      )),
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        top: 10,
                                                        left: 0,
                                                        right: 20,
                                                        child: Container(
                                                          height: 30,
                                                          color: Colors
                                                              .transparent,
                                                          child: Marquee(
                                                            text:
                                                                documentSnapshot[
                                                                    i]["title"],
                                                            blankSpace: 30,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            pauseAfterRound:
                                                                const Duration(
                                                                    seconds: 2),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 35,
                                                        left: 0,
                                                        right: 45,
                                                        child: Container(
                                                          height: 30,
                                                          color: Colors
                                                              .transparent,
                                                          child: Marquee(
                                                            text:
                                                                "By ${documentSnapshot[i]["author"]}",
                                                            blankSpace: 20,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            pauseAfterRound:
                                                                const Duration(
                                                                    seconds: 2),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 115,
                                                        left: 92,
                                                        right: 0,
                                                        child: Container(
                                                          height: 45,
                                                          width: 15,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Icon(
                                                            Icons
                                                                .play_arrow_rounded,
                                                            size: 35,
                                                            color:
                                                                kPrimaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            builder: (_, value, child) {
                                              return Transform.scale(
                                                scale: scale,
                                                child: child,
                                              );
                                            });
                                      }),
                                ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                /* Positioned(
                  top: 180,
                  left: 0,
                  right: 0,
                  child: SearchBarUtil().searchBarContainer(matchStoryList),
                ),*/
                Positioned(
                  top: 490,
                  left: 20,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.myStories,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 528,
                  left: 30,
                  right: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*StoryListItem(
                        story: Story(
                          id: "test",
                          title: "Mein kleines Märchen",
                          imageUrl: "http://placekitten.com/256/256",
                        ),
                      ),*/
                      SizedBox(
                        height: 260,
                        child: StreamBuilder(
                          stream: _storiesStream,
                          // _storiesQuery!.snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              print("Loading!");
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Column(
                                children: snapshot.data!.docs.map((element) {
                              return StoryListItem(
                                story: element.data(),
                                buttons: [
                                  StoryActionButton(
                                    icon: element.data().liked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    onTap: () {},
                                  )
                                ],
                              );
                            }).toList());
                            // return SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
