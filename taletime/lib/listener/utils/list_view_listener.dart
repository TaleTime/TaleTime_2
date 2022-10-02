
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../common utils/constants.dart';
import 'icon_context_dialog.dart';

class MyListView extends StatefulWidget{
  final List stories;
  final CollectionReference storiesCollection;
  final profile;
  final profiles;
  const MyListView(this.stories, this.storiesCollection, this.profile, this.profiles,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyListViewState(this.stories, this.storiesCollection, this.profile, this.profiles);
  }
}

class _MyListViewState extends State<MyListView>{

  final List stories;
  final CollectionReference storiesCollection;
  final profile;
  final profiles;

  late final String newAudio;
  late final String newImage;
  late final String newTitle;
  late final bool newIsLiked;
  late final String newAuthor;
  late final String newRating;
  late final String newId;

  _MyListViewState(this.stories, this.storiesCollection, this.profile, this.profiles);

  final List<IconData> _icons = [
    Icons.favorite,
    Icons.favorite_border,
  ];

  @override
  Widget build (BuildContext context){
    final double screenWidth = MediaQuery.of(context).size.width;
    CollectionReference favorites = profiles.doc(profile["id"]).collection('favoriteList');

    Future<void> updateStory(String storyId, bool isLiked) {
      return storiesCollection
          .doc(storyId)
          .update({'isLiked': isLiked})
          .then((value) => print("Story liked/disliked"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    Future<void> updateFavoriteList(String storyId) {
      return favorites
          .doc(storyId)
          .update({'id': storyId})
          .then((value) => print("List Updated"))
          .catchError((error) => print("Failed to update List: $error"));
    }

    Future<void> addStory(
        String audio,
        String author,
        String image,
        String title,
        String rating,
        bool isLiked,
        /*String id*/) {
      return favorites.add({
        'id': "",
        'image': image,
        'audio': audio,
        'title': title,
        'rating': rating,
        'author': author,
        'isLiked': isLiked
      }).then((value) {
        print("Story Added to favorites");
        updateFavoriteList(value.id);
      }).catchError((error) => print("Failed to add story to favorites: $error"));
    }

    return ListView.builder(
        primary: false,
        itemCount: stories.length,
        itemBuilder: (_,i){
          bool hasLiked = stories[i]["isLiked"];
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
                                    icon: hasLiked == false ? Icon(_icons[1], size: 21, color: Colors.white,) : Icon(_icons[0], size: 21, color: Colors.white,),
                                    onPressed: () {
                                      if (!hasLiked){
                                        setState(() {
                                          hasLiked = true;
                                          updateStory(stories[i]["id"], true);
                                          newAudio = stories[i]["audio"];
                                          newImage = stories[i]["image"];
                                          newTitle = stories[i]["title"];
                                          newIsLiked = true;
                                          newAuthor = stories[i]["author"];
                                          newRating = stories[i]["rating"];
                                          //newId = stories[i]["id"];
                                          addStory(newAudio,newAuthor,newImage,newTitle,newRating,newIsLiked/*,newId*/);
                                        });
                                      }else{
                                        setState(() {
                                          hasLiked = false;
                                          updateStory(stories[i]["id"], false);
                                          favorites.doc(stories[i]["id"]).delete()
                                              .then((value) => print("story Deleted"))
                                              .catchError((error) => print("Failed to delete story: $error"));
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