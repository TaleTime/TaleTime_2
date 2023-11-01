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
  final ScrollController _scrollController = ScrollController();

  Color _appbarColor = Colors.transparent;

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

    _scrollController.addListener(() {
      if (_scrollController.offset < 40 && _appbarColor == Colors.white) {
        setState(() {
          _appbarColor = Colors.transparent;
        });
      } else if (_scrollController.offset >= 40 && _appbarColor == Colors.transparent) {
        setState(() {
          _appbarColor = Colors.white;
        });
      }
    });
  }

  Widget _buildStoriesList(BuildContext context) {
    return StreamBuilder(
      stream: _storiesStream,
      builder: (context, snapshot) {
        var stories = snapshot.data;

        if (stories == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: stories.docs.map((element) {
            AddedStory story = element.data();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: StoryListItem(
                story: story,
                buttons: [
                  if (story.liked)
                    StoryActionButton(
                      icon: Icons.favorite,
                      onTap: () {},
                    )
                  else
                    StoryActionButton(
                      icon: Icons.favorite_border,
                      onTap: () {},
                    )
                ],
              ),
            );
          }).toList(),
        );
        // return SizedBox();
      },
    );
  }

  Widget _buildRecentlyPlayed(BuildContext context) {
    return StreamBuilder(
        stream: _recentlyPlayedStoriesStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<QueryDocumentSnapshot> documentSnapshot =
                streamSnapshot.data!.docs;
            return documentSnapshot.isEmpty
                ? Decorations().noRecentContent(
                    AppLocalizations.of(context)!.noStoriesAvailable,
                    "recentStories")
                : SizedBox(
                    height: 190,
                    child: PageView.builder(
                        onPageChanged: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        controller: PageController(viewportFraction: 0.4),
                        itemCount: documentSnapshot == null
                            ? 0
                            : documentSnapshot.length,
                        itemBuilder: (_, i) {
                          var scale = _selectedIndex == i ? 1.0 : 0.8;
                          return TweenAnimationBuilder(
                              duration: const Duration(microseconds: 350),
                              tween: Tween(begin: scale, end: scale),
                              curve: Curves.ease,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return MyPlayStory(documentSnapshot[i],
                                          widget.storiesCollection);
                                    }));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 30),
                                    height: 180,
                                    width: 85,
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 15, right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(18),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              documentSnapshot[i]["image"] ==
                                                      ""
                                                  ? storyImagePlaceholder
                                                  : documentSnapshot[i]
                                                      ["image"]),
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.6),
                                              BlendMode.dstATop),
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
                                            color: Colors.transparent,
                                            child: Marquee(
                                              text: documentSnapshot[i]
                                                  ["title"],
                                              blankSpace: 30,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold),
                                              pauseAfterRound:
                                                  const Duration(seconds: 2),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 35,
                                          left: 0,
                                          right: 45,
                                          child: Container(
                                            height: 30,
                                            color: Colors.transparent,
                                            child: Marquee(
                                              text:
                                                  "By ${documentSnapshot[i]["author"]}",
                                              blankSpace: 20,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.bold),
                                              pauseAfterRound:
                                                  const Duration(seconds: 2),
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
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.play_arrow_rounded,
                                              size: 35,
                                              color: kPrimaryColor,
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
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: _appbarColor,
        shadowColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingsPage(widget.profile, widget.profiles)));
            },
            icon: Icon(Icons.menu,
                size: 33, color: kPrimaryColor, //kPrimaryColor
            ),
          )
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.hello},",
                        style: TextStyle(color: Colors.brown.shade600, fontSize: 15),
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
                            hintStyle:
                                const TextStyle(color: Colors.grey, fontSize: 18),
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
                  _buildRecentlyPlayed(context),
                  Column(
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
                  _buildStoriesList(context),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
