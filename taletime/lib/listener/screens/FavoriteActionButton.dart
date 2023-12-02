import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/listener/screens/ListenerActionButtons.dart";
import "../../common/models/story.dart";
import "../../common/widgets/story_list_item.dart";

class FavoriteActionButton extends ListenerActionButtons{
  final CollectionReference favorites;

  FavoriteActionButton(this.favorites);


  void likeStory(){
  }


  @override
  List<StoryActionButton> build(BuildContext context, Story story) {
    return [
      StoryActionButton(
          icon: Icons.favorite,
          onTap: () => {
      }
      )
    ];
    }
}