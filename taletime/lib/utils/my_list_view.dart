
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'icon_context_dialog.dart';

class MyListView extends StatefulWidget{
  final List stories;
  final CollectionReference storiesCollection;
  const MyListView(this.stories, this.storiesCollection,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyListViewState(this.stories, this.storiesCollection);
  }
}

class _MyListViewState extends State<MyListView>{

  final List stories;
  final CollectionReference storiesCollection;

  _MyListViewState(this.stories, this.storiesCollection);

  final List<IconData> _icons = [
    Icons.favorite,
    Icons.favorite_border,
  ];

  @override
  Widget build (BuildContext context){
    final double screenWidth = MediaQuery.of(context).size.width;

    void updateFavoriteItem(String audio, String author, String id, String image, bool isLiked, String rating, String title) {
      setState(() {
        favoriteStory = {
          "rating": rating,
          "title": title,
          "author": author,
          "image": image,
          "audio": audio,
          "isLiked": isLiked,
          "id": id
        };
      });
    }

    Future<void> updateFavoriteList(List favorites, String profileId, Map favoriteItem) {
      favorites.add(favoriteItem);
      return profiles
          .doc(profileId)
          .update({'favorites': favorites})
          .then((value) => print("profile Updated"))
          .catchError((error) => print("Failed to update profile: $error"));
    }

    return ListView.builder(
        primary: false,
        itemCount: stories.length,
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
                                child: Image.network(stories[i]["image"] == "" ? storyImagePlaceholder : stories[i]["image"]),
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
                                          stories[i]["rating"],
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
                                        stories[i]["title"],
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
                                        "By ${stories[i]["author"]}",
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
                                  IconButton(
                                    icon: stories[i]["isLiked"] == false ? Icon(_icons[1], size: 21, color: Colors.white,) : Icon(_icons[0], size: 21, color: Colors.white,),
                                    onPressed: () {
                                      if (!stories[i]["isLiked"]){
                                        setState(() {
                                          stories[i]["isLiked"] = true;
                                          stories[i].update({'isLiked': true})
                                              .then((value) => print("User Updated"))
                                              .catchError((error) => print("Failed to update user: $error"));
                                        });
                                      }else{
                                        setState(() {
                                          stories[i]["isLiked"] = false;
                                          stories[i].update({'isLiked': false})
                                              .then((value) => print("User Updated"))
                                              .catchError((error) => print("Failed to update user: $error"));
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  IconContextDialog("Delete Story...",
                                    "Do you really want to delete this story?",
                                    Icons.delete,
                                      stories[i]["id"],
                                      storiesCollection
                                  ),
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

        });
  }
}