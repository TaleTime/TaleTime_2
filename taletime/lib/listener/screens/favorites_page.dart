import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/common/services/story_service.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/state/profile_state.dart";

import "../../common/widgets/story_list_item.dart";
import "listener_taletime_page.dart";

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List matchStoryList = [];

  _FavoritePageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileState>(
      builder: (context, profileState, _) => StreamBuilder(
          stream: profileState.storiesRef
              ?.where("isLiked", isEqualTo: true)
              .snapshots(),
          builder: (context, streamSnapshot) {
            final data = streamSnapshot.data;
            if (data == null) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final docs = data.docs;

            return ListenerTaletimePage<AddedStory>(
              title: AppLocalizations.of(context)!.favorites,
              docs: docs,
              buttonsBuilder: (e) => [
                StoryActionButton(
                    icon: Icons.favorite,
                    onTap: () => StoryService.likeStory(e.reference, false))
              ],
            );
          }),
    );
  }
}
