import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/list_view_story_teller.dart';
import '../utils/decoration_util.dart';

class SpeakerHomePage extends StatefulWidget {
  final DocumentSnapshot profile;
  const SpeakerHomePage(this.profile, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SpeakerHomePageState(this.profile);
  }
}

class _SpeakerHomePageState extends State<SpeakerHomePage> {
  var _selecetedIndex = 0;

  late final DocumentSnapshot profile;
  List matchStoryList = [];
  _SpeakerHomePageState(this.profile);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(children: [
      Positioned(
        top: 10,
        left: 8,
        right: 16,
        child: AppBar(
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
              "Hello,",
              style: TextStyle(color: Colors.brown.shade600, fontSize: 15),
            ),
            Text(
              profile["name"],
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 42,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    List stories = profile["stories"];
                    matchStoryList = stories
                        .where((story) => story["title"]
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                  if (value == "") {
                    matchStoryList.length = 0;
                  }
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
                  hintText: "Search stories...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              child: Text(
                "Last Recorded",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
      ),
      Positioned(
        top: 270,
        left: -90,
        right: 0,
        child: profile["recent"].length == 0
            ? Decorations().noRecentContent(
                "Nothing to show yet. \nplease add some stories to your story library",
                "recentStories")
            : Container(
                height: 190,
                child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        _selecetedIndex = index;
                      });
                    },
                    controller: PageController(viewportFraction: 0.4),
                    itemCount: profile["recent"] == null
                        ? 0
                        : profile["recent"].length,
                    itemBuilder: (_, i) {
                      var _scale = _selecetedIndex == i ? 1.0 : 0.8;
                      return TweenAnimationBuilder(
                          duration: const Duration(microseconds: 350),
                          tween: Tween(begin: _scale, end: _scale),
                          curve: Curves.ease,
                          child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(right: 30),
                                height: 180,
                                width: 85,
                                padding: EdgeInsets.only(
                                    top: 15, left: 15, right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(18),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          profile["recent"][i]["image"] == ""
                                              ? storyImagePlaceholder
                                              : profile["recent"][i]["image"]),
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
                                          text: profile["recent"][i]["title"],
                                          blankSpace: 30,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          pauseAfterRound: Duration(seconds: 2),
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
                                              "By ${profile["recent"][i]["author"]}",
                                          blankSpace: 20,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          pauseAfterRound: Duration(seconds: 2),
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
                              scale: _scale,
                              child: child,
                            );
                          });
                    }),
              ),
      ),
      Positioned(
        top: 180,
        left: 0,
        right: 0,
        child: Container(
          margin: EdgeInsets.all(15),
          height: matchStoryList.isNotEmpty
              ? (matchStoryList.length >= 4
                  ? (63.0 * 4.5)
                  : 63.0 * matchStoryList.length)
              : 0.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.teal.shade600,
          ),
          child: ListView.builder(
            primary: false,
            itemCount: matchStoryList.length,
            itemBuilder: (context, index) {
              var resultTitle = matchStoryList[index]["title"];
              var resultAuthor = matchStoryList[index]["author"];
              var resultImage = matchStoryList[index]["image"] == ""
                  ? storyImagePlaceholder
                  : matchStoryList[index]["image"];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpeakerHomePage(profile)));
                },
                child: ListTile(
                  title: Text(
                    resultTitle,
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    resultAuthor,
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Image.network(resultImage),
                ),
              );
            },
          ),
        ),
      ),
      Positioned(
        top: 490,
        left: 20,
        right: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "My Recorded Stories",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                ),
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
            Container(
              height: 260,
              child: profile["stories"].length == 0
                  ? Decorations().noRecentContent(
                      "No stories yet. \nplease add some stories to your story library",
                      "")
                  : ListViewStoryTeller(profile["stories"]),
            ),
          ],
        ),
      ),
    ]));
  }
}
