import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';
import '../utils/decoration_util.dart';
import '../utils/my_list_view.dart';
import '../utils/search-bar-util.dart';

class FavoritePage extends StatefulWidget {
  final profile;
  final profiles;
  final favorites;
  const FavoritePage(this.profile, this.profiles, this.favorites, {Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState(this.profile, this.profiles, this.favorites);
}

class _FavoritePageState extends State<FavoritePage> {
  final profile;
  final profiles;
  final favorites;
  List matchStoryList = [];

  _FavoritePageState(this.profile, this.profiles, this.favorites);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: favorites.snapshots(),
      builder:
          (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          final List<QueryDocumentSnapshot> documentSnapshot =
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
                        "Favorites",
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
                    top: 80,
                    left: 22,
                    right: 28,
                    height: screenHeight * 0.34,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 42,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                matchStoryList = SearchBarUtil().searchStory(documentSnapshot, value);
                              });
                              SearchBarUtil().isStoryListEmpty(matchStoryList, value);
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
                      ],
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: 15,
                    right: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenHeight * 0.8,
                          child: documentSnapshot.length == 0
                              ? Decorations().noRecentContent(
                              "No stories yet. \nplease add some stories to your story library",
                              "")
                              :MyListView(documentSnapshot, favorites, profile, profiles),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 115,
                    left: 0,
                    right: 0,
                    child: SearchBarUtil().searchBarContainer(matchStoryList),
                  ),
                ],
              ));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

      /*Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 10,
              left: 8,
              right: 16,
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  "Favorites",
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
              top: 80,
              left: 22,
              right: 28,
              height: screenHeight * 0.34,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 42,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          //List stories = profile["favorites"];
                          matchStoryList = SearchBarUtil().searchStory(favorites, value);
                        });
                        SearchBarUtil().isStoryListEmpty(matchStoryList, value);
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
                ],
              ),
            ),
            Positioned(
              top: 150,
              left: 15,
              right: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: screenHeight * 0.8,
                    child: MyListView(favorites),
                  )
                ],
              ),
            ),
            Positioned(
              top: 115,
              left: 0,
              right: 0,
              child: SearchBarUtil().searchBarContainer(matchStoryList, profile, profiles),
            ),
          ],
        ));*/
  }
}
