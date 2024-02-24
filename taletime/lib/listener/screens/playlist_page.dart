import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/common/models/play_list.dart";
import "package:taletime/listener/utils/playlist_list.dart";

import "../../state/profile_state.dart";
import "package:taletime/common%20utils/constants.dart";

import "edit_playlist_page.dart";

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context) {
    var playlists = Provider.of<ProfileState>(context).playlists;

    if (playlists == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          toolbarOpacity: 0,
          title: const Text(
            "Playlists",
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          actions: <Widget>[
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
                          playlist: Playlist(
                            id: null,
                            title: "",
                            description: "",
                            image: null,
                            stories: [],
                          ),
                        ),
                      ),
                    );
                  },
                  value: "edit",
                  child: const Text("Edit"),
                ),
                PopupMenuItem(
                  onTap: () {},
                  value: "delete",
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
            child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final Playlist playlist = playlists[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlaylistList(playlist: playlist),
            );
          },
        )));
  }
}
