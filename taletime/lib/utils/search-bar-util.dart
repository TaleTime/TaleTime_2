
import 'package:flutter/material.dart';
import 'constants.dart';

class SearchBarUtil {

  List searchStory(List stories, value){
    return stories
        .where((story) => story["title"]
        .toLowerCase()
        .contains(value.toLowerCase()))
        .toList();
  }

  void isStoryListEmpty(List story, value){
    if (value == "") {
      story.length = 0;
    }
  }

  Container searchBarContainer(List story, profile) {
    return Container(
      margin: EdgeInsets.all(15),
      height: story.isNotEmpty
          ? (story.length >= 4
          ? (63.0 * 4.5)
          : 63.0 * story.length)
          : 0.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.teal.shade600,
      ),
      child: ListView.builder(
        primary: false,
        itemCount: story.length,
        itemBuilder: (context, index) {
          var resultTitle = story[index]["title"];
          var resultAuthor = story[index]["author"];
          var resultImage = story[index]["image"] == ""
              ? storyImagePlaceholder
              : story[index]["image"];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
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
    );
  }
}