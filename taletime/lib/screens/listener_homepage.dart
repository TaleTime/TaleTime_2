import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/constants.dart';

class ListenerHomePage extends StatefulWidget {
  const ListenerHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListenerHomePageState();
  }
}

class _ListenerHomePageState extends State<ListenerHomePage> {
  var _selecetedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    void updateList(String value) {
      // method to update list when searching
    }

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
                  "Taletime User!",
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
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Recently Played",
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
            child: Container(
              height: 190,
              child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      _selecetedIndex = index;
                    });
                  },
                  controller: PageController(viewportFraction: 0.4),
                  itemCount: 10,
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
                              padding:
                              EdgeInsets.only(top: 15, left: 15, right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(18),
                                  image: DecorationImage(
                                    image: AssetImage("logo.png"),
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
                                        text: "Wonderful-Story",
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
                                        text: "By Taletime-Story-teller",
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
                                        borderRadius: BorderRadius.circular(8),
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
            top: 490,
            left: 20,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "My Stories",
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
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              height: 75,
                              margin: EdgeInsets.only(bottom: 9),
                              padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: kPrimaryColor,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                    ),
                                    child: Image.network(
                                      assetLogo,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Text(
                                            "4.5",
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 17,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Wonderful-Story",
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "By Taletime-story-teller",
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 80,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
