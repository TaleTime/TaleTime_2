import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/add_icon_context_dialog.dart';
import '../utils/constants.dart';
import '../utils/search-bar-util.dart';

class AddStory extends StatefulWidget {
  final CollectionReference storiesCollectionReference;
  final CollectionReference allStoriesCollectionReference;

  const AddStory(this.storiesCollectionReference, this.allStoriesCollectionReference, {Key? key}) : super(key: key);

  @override
  State<AddStory> createState() => _AddStoryState(this.storiesCollectionReference, this.allStoriesCollectionReference);
}

class _AddStoryState extends State<AddStory> {

  final CollectionReference storiesCollectionReference;
  final CollectionReference allStoriesCollectionReference;

  List matchStoryList = [];

  _AddStoryState(this.storiesCollectionReference, this.allStoriesCollectionReference);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: allStoriesCollectionReference.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<QueryDocumentSnapshot> storiesDocumentSnapshot = streamSnapshot.data!.docs;
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
                          "Add Story",
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
                                  matchStoryList = SearchBarUtil().searchStory(storiesDocumentSnapshot, value);
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
                            child: ListView.builder(
                                primary: false,
                                itemCount: storiesDocumentSnapshot.length,
                                itemBuilder: (_,i){
                                  return
                                    GestureDetector(
                                      onTap: (){},
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 85,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 75,
                                                  margin: EdgeInsets.only(bottom: 9),
                                                  padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(11),
                                                    color: Colors.teal.shade600,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15),
                                                          color: Colors.transparent,
                                                        ),
                                                        child: Image.network(storiesDocumentSnapshot[i]["image"] == "" ? storyImagePlaceholder : storiesDocumentSnapshot[i]["image"]),
                                                      ),
                                                      SizedBox(width: 20,),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 2),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  storiesDocumentSnapshot[i]["rating"],
                                                                  style: const TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 12.0
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Icon(
                                                                  Icons.star,
                                                                  color: Colors.white,
                                                                  size: 14,
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              width: screenWidth * 0.4,
                                                              child: Text(
                                                                storiesDocumentSnapshot[i]["title"],
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 15.0,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: screenWidth * 0.4,
                                                              child: Text(
                                                                "By ${storiesDocumentSnapshot[i]["author"]}",
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 13.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(flex: 3, child: Container(),),
                                                      Row(
                                                        children: [
                                                          AddIconContextDialog(
                                                              "Add Story...",
                                                              "Do you really want to add this story?",
                                                              Icons.playlist_add_outlined,
                                                              storiesCollectionReference,
                                                              storiesDocumentSnapshot[i]),
                                                          const SizedBox(
                                                            width: 1,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                }),
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
        }
        );
  }
}
