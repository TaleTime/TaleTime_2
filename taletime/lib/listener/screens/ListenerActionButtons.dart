import "package:flutter/cupertino.dart";
import "package:taletime/common/models/added_story.dart";

import "../../common/models/story.dart";
import "../../common/widgets/story_list_item.dart";

abstract class ListenerActionButtons {
  List<StoryActionButton> build(BuildContext context, Story story);
}