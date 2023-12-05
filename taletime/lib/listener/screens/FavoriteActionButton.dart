import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/common/services/story_service.dart";
import "package:taletime/listener/screens/ListenerActionButtons.dart";
import "../../common/widgets/story_list_item.dart";

class FavoriteActionButton extends ListenerActionButtons {

  List<StoryActionButton> build(BuildContext context, DocumentReference<AddedStory> story) {
    return [StoryActionButton(icon: Icons.favorite, onTap: () => StoryService.likeStory(story, false))];
  }
}
