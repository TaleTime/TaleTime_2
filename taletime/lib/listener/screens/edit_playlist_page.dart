import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/state/profile_state.dart";

import "../../common/models/play_list.dart";
import "../../common/models/story.dart";
import "../../common/widgets/story_list_item.dart";
import "../../internationalization/localizations_ext.dart";

class EditPlaylistPage extends StatefulWidget {
  final Playlist playlist;

  const EditPlaylistPage({super.key, required this.playlist});

  @override
  State<EditPlaylistPage> createState() => _EditPlaylistPageState();
}

class _EditPlaylistPageState extends State<EditPlaylistPage> {
  late List<AddedStory> playlistStories;

  @override
  void initState() {
    super.initState();

    playlistStories = [...(widget.playlist.stories ?? [])];
  }

  @override
  Widget build(BuildContext context) {
    var myStories = Provider.of<ProfileState>(context).stories;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Playlist",
              style: TextStyle(fontSize: 24, color: Colors.white)),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Title",
                  ),
                  controller:
                      TextEditingController(text: widget.playlist.title),
                  onChanged: (value) {
                    widget.playlist.title = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.description,
                  ),
                  controller:
                      TextEditingController(text: widget.playlist.description),
                  onChanged: (value) {
                    widget.playlist.description = value;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.stories),
                    ElevatedButton(
                        child: const Icon(Icons.add),
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: StatefulBuilder(
                                  builder: (context, setDialogState) {
                                var notAddedStories = myStories
                                    ?.where((element) =>
                                        !playlistStories.contains(element))
                                    .toList();

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(AppLocalizations.of(context)!
                                          .playlistAddStory),
                                      const SizedBox(height: 15),
                                      Expanded(
                                          child: ListView.builder(
                                        padding: const EdgeInsets.all(8),
                                        itemCount: notAddedStories != null
                                            ? notAddedStories.length
                                            : 0,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: StoryListItem(
                                                  story:
                                                      notAddedStories![index],
                                                  buttons: [
                                                    StoryActionButton(
                                                        icon: Icons.add,
                                                        onTap: () {
                                                          setState(() {
                                                            setDialogState(() {
                                                              playlistStories.add(
                                                                  notAddedStories[
                                                                      index]);
                                                            });
                                                          });
                                                        })
                                                  ]));
                                        },
                                      )),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .close),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          );
                        })
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: playlistStories.length,
                    itemBuilder: (context, index) {
                      final Story story = playlistStories[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: StoryListItem(story: story, buttons: [
                          StoryActionButton(
                            icon: Icons.remove,
                            onTap: () {
                              setState(() {
                                playlistStories.remove(story);
                              });
                            },
                          )
                        ]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.playlist.stories = playlistStories;
            if (widget.playlist.id != null) {
              Provider.of<ProfileState>(context, listen: false)
                  .playlistsRef
                  ?.doc(widget.playlist.id)
                  .set(widget.playlist);
            } else {
              Provider.of<ProfileState>(context, listen: false)
                  .playlistsRef
                  ?.add(widget.playlist);
            }
            Navigator.pop(context);
          },
          child: const Icon(Icons.save),
        ));
  }
}
