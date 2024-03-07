import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/common/widgets/story_list_item.dart";
import "package:taletime/listener/screens/edit_playlist_page.dart";
import "package:taletime/player/models/custom_player_state.dart";

import "../../common/models/play_list.dart";
import "../../internationalization/localizations_ext.dart";
import "../../main.dart";
import "../../player/screens/story_player.dart";
import "../../state/profile_state.dart";

class DetailedPlaylistPage extends StatelessWidget {
  final Playlist playlist;

  const DetailedPlaylistPage({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(playlist.title!,
              style: const TextStyle(fontSize: 24, color: Colors.white)),
          actions: [
            PopupMenuButton(
              offset: const Offset(0, 40),
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPlaylistPage(
                          playlist: playlist,
                        ),
                      ),
                    );
                  },
                  value: AppLocalizations.of(context)!.edit,
                  child: Text(AppLocalizations.of(context)!.edit),
                ),
                PopupMenuItem(
                  onTap: () {
                    Provider.of<ProfileState>(context, listen: false)
                        .playlistsRef
                        ?.doc(playlist.id)
                        .delete();
                    Navigator.pop(context);
                  },
                  value: AppLocalizations.of(context)!.delete,
                  child: Text(AppLocalizations.of(context)!.delete),
                ),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playlist.description ?? "No description",
                textAlign: TextAlign.left,
                softWrap: true,
                style: const TextStyle(fontSize: 16, color: Colors.black45),
              ),
              const SizedBox(width: 8.0),
              Text(AppLocalizations.of(context)!.stories,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, color: Colors.black)),
              SingleChildScrollView(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    playlist.stories != null ? playlist.stories!.length : 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StoryListItem(
                      story: playlist.stories![index],
                      buttons: [
                        StoryActionButton(
                          icon: Icons.play_arrow,
                          onTap: () {
                            if (playlist.stories == null) return;
                            if (audioHandler.customState.value
                                is CustomPlayerState) {
                              var state = audioHandler.customState.value
                                  as CustomPlayerState;
                              state.setPlaylist(playlist.stories!);
                              state.currentStoryPlayed = index;
                            }
                            StoryPlayer.playStory(
                                context, playlist.stories![index]);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const StoryPlayer(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              )),
            ],
          ),
        ));
  }
}
