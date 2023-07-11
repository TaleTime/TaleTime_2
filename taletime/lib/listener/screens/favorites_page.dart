import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/listener/utils/search_bar_util.dart";
import "package:taletime/listener/utils/list_view.dart";

class FavoritePage extends StatefulWidget {
  final profile;
  final profiles;
  final favorites;
  final storiesColl;
  const FavoritePage(this.profile, this.profiles, this.favorites, this.storiesColl, {Key? key})
      : super(key: key);

  @override
  State<FavoritePage> createState() =>
      _FavoritePageState(profile, profiles, favorites, storiesColl);
}

class _FavoritePageState extends State<FavoritePage> {
  final profile;
  final profiles;
  final favorites;
  final storiesColl;
  List matchStoryList = [];

  _FavoritePageState(this.profile, this.profiles, this.favorites, this.storiesColl);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<QuerySnapshot>(
      stream: favorites.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          final List<QueryDocumentSnapshot> documentSnapshot = streamSnapshot.data!.docs;

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
                    title: Text(
                      "Favorites",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                    elevation: 0.0,
                    actions: <Widget>[
                      IconButton(
                        onPressed: () {}, //3 dots button in fav page TODO
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
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
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
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                            suffixIcon: const Icon(
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
                      SizedBox(
                        height: screenHeight * 0.8,
                        child: ListViewData(
                            documentSnapshot, storiesColl, profile, profiles, "favList", favorites),
                      ),
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
