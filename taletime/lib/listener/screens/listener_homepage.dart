import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:marquee/marquee.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/listener/screens/my_play_story.dart";
import "package:taletime/listener/utils/my_list_view_listener.dart";

import "../../common utils/decoration_util.dart";
import "../utils/search_bar_util.dart";

class ListenerHomePage extends StatefulWidget {
  final DocumentSnapshot profile;
  final profiles;
  final CollectionReference storiesCollection;
  final CollectionReference recentCollection;
  const ListenerHomePage(this.profile, this.profiles, this.storiesCollection,
      this.recentCollection,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListenerHomePageState();
  }
}

class _ListenerHomePageState extends State<ListenerHomePage> {
  var _selectedIndex = 0;
  List matchStoryList = [];

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
                body: Stack(children: [
              Positioned(
                top: 10,
                left: 8,
                right: 16,
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.menu,
                        size: 33,
                        color: kPrimaryColor,
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
                      AppLocalizations.of(context)!.listener_home_welcomeText,
                      style:
                          TextStyle(color: Colors.brown.shade600, fontSize: 15),
                    ),
                    Text(
                      widget.profile["name"],
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
                          hintText: AppLocalizations.of(context)!
                              .listener_home_searchbarHint,
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
                        AppLocalizations.of(context)!
                            .listener_home_recentlyPlayed,
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
                  stream: widget.storiesCollection.snapshots(),
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
                                    .listener_home_recentlyPlayedEmptyHint,
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
                                          duration:
                                              const Duration(microseconds: 350),
                                          tween:
                                              Tween(begin: scale, end: scale),
                                          curve: Curves.ease,
                                          child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return MyPlayStory(
                                                      documentSnapshot[i]);
                                                }));
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 30),
                                                height: 180,
                                                width: 85,
                                                padding: const EdgeInsets.only(
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
                                                                  i]["image"]),
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
                                                        color:
                                                            Colors.transparent,
                                                        child: Marquee(
                                                          text:
                                                              documentSnapshot[
                                                                  i]["title"],
                                                          blankSpace: 30,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                        color:
                                                            Colors.transparent,
                                                        child: Marquee(
                                                          text:
                                                              "By ${documentSnapshot[i]["author"]}",
                                                          blankSpace: 20,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                                  .circular(8),
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .play_arrow_rounded,
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
                              ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              Positioned(
                top: 180,
                left: 0,
                right: 0,
                child: SearchBarUtil().searchBarContainer(matchStoryList),
              ),
              Positioned(
                top: 490,
                left: 20,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.listener_home_myStories,
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
                    SizedBox(
                      height: 260,
                      child: StreamBuilder(
                        stream: widget.storiesCollection.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return storiesDocumentSnapshot.isEmpty
                              ? Decorations().noRecentContent(
                                  AppLocalizations.of(context)!
                                      .listener_home_myStoriesEmptyHint,
                                  "")
                              : MyListViewListener(
                                  storiesDocumentSnapshot,
                                  widget.storiesCollection,
                                  widget.profile,
                                  widget.profiles);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
