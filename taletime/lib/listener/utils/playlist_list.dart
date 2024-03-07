import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:taletime/listener/screens/detailed_playlist_page.dart";

import "../../common/models/play_list.dart";
import "../../internationalization/localizations_ext.dart";

class PlaylistList extends StatelessWidget {
  final Playlist playlist;

  const PlaylistList({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.teal.shade600,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      child: GestureDetector(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedPlaylistPage(
                playlist: playlist,
              ),
            ),
          );
        },
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              image: (playlist.image != null
                                      ? NetworkImage(playlist.image!)
                                      : const AssetImage("assets/logo.png"))
                                  as ImageProvider<Object>,
                              fit: BoxFit.cover,
                              width: 64,
                              height: 64,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playlist.title ??
                                      AppLocalizations.of(context)!.noName,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  playlist.description ??
                                      AppLocalizations.of(context)!.noDescriptionAvailable,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                )
                              ],
                            )),
                          ]),
                      const SizedBox(height: 4.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
