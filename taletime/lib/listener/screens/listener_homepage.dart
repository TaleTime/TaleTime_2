import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common/models/added_story.dart";
import "package:taletime/common/services/story_service.dart";
import "package:taletime/common/widgets/story_card.dart";
import "package:taletime/common/widgets/story_list_item.dart";
import "package:taletime/common/widgets/tale_time_alert_dialog.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import 'package:taletime/player/screens/story_player.dart';
import "package:taletime/profiles/models/profile_model.dart";

import "../../common utils/decoration_util.dart";
import "../../settings/settings.dart";

class ListenerHomePage extends StatefulWidget {
  final Profile profile;
  final CollectionReference<Profile> profiles;
  final CollectionReference<AddedStory> storiesCollection;

  const ListenerHomePage({
    super.key,
    required this.profile,
    required this.profiles,
    required this.storiesCollection,
  });

  @override
  State<StatefulWidget> createState() {
    return _ListenerHomePageState();
  }
}

class _ListenerHomePageState extends State<ListenerHomePage> {
  _ListenerHomePageState();

  var _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  bool _appBarTransparent = true;

  Stream<QuerySnapshot<AddedStory>>? _storiesStream;
  Stream<QuerySnapshot<AddedStory>>? _recentlyPlayedStoriesStream;

  @override
  void initState() {
    super.initState();

    _storiesStream = widget.storiesCollection.snapshots();

    _recentlyPlayedStoriesStream = widget.storiesCollection
        .where("timeLastPlayed", isNotEqualTo: null)
        .orderBy("timeLastPlayed", descending: true)
        .limit(10)
        .snapshots();

    _scrollController.addListener(() {
      if (_scrollController.offset < 40 && _appBarTransparent == false) {
        setState(() {
          _appBarTransparent = true;
        });
      } else if (_scrollController.offset >= 40 && _appBarTransparent == true) {
        setState(() {
          _appBarTransparent = false;
        });
      }
    });
  }

  void _deleteStory(DocumentReference<AddedStory> story, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TaleTimeAlertDialog(
        title: AppLocalizations.of(context)!.storyDeleteHint,
        content: AppLocalizations.of(context)!.storyDeleteHintDescription,
        buttons: [
          AlertDialogButton(
            text: AppLocalizations.of(context)!.yes,
            onPressed: () {
              StoryService.deleteStory(story);
              Navigator.of(context).pop();
            },
          ),
          AlertDialogButton(
            text: AppLocalizations.of(context)!.no,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesList(BuildContext context) {
    return StreamBuilder(
      stream: _storiesStream,
      builder: (context, snapshot) {
        var stories = snapshot.data;

        if (stories == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: stories.docs.map((element) {
            AddedStory story = element.data();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: StoryListItem(
                story: story,
                onTap: () {
                  StoryPlayer.playStory(context, story);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StoryPlayer(),
                    ),
                  );
                },
                buttons: [
                  StoryActionButton(
                    icon: story.liked ? Icons.favorite : Icons.favorite_border,
                    onTap: () {
                      StoryService.likeStory(element.reference, !story.liked);
                    },
                  ),
                  StoryActionButton(
                      icon: Icons.delete_outline,
                      onTap: () {
                        _deleteStory(element.reference, context);
                      }),
                ],
              ),
            );
          }).toList(),
        );
        // return SizedBox();
      },
    );
  }

  Widget _buildRecentlyPlayed(BuildContext context) {
    return StreamBuilder(
        stream: _recentlyPlayedStoriesStream,
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
          return docs.isEmpty
              ? Decorations().noRecentContent(
                  AppLocalizations.of(context)!.noStoriesAvailable,
                  "recentStories")
              : SizedBox(
                  height: 180,
                  child: PageView.builder(
                      onPageChanged: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      controller: PageController(viewportFraction: 0.6),
                      itemCount: docs.length,
                      itemBuilder: (_, i) {
                        var scale = _selectedIndex == i ? 1.0 : 0.8;
                        return TweenAnimationBuilder(
                            duration: const Duration(microseconds: 350000),
                            tween: Tween(begin: scale, end: scale),
                            curve: Curves.ease,
                            child: StoryCard(
                              story: docs[i].data(),
                              onTap: () {},
                            ),
                            builder: (_, value, child) {
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            });
                      }),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: _appBarTransparent
            ? Colors.transparent
            : Theme.of(context).colorScheme.background,
        shadowColor: Colors.white,
        title: _appBarTransparent
            ? null
            : Text(
                AppLocalizations.of(context)!.myStories,
                style: TextStyle(color: Colors.teal.shade600),
              ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const StoryPlayer(),
              ));
            },
            icon: Icon(
              Icons.playlist_play_outlined,
              color: kPrimaryColor,
            ),

          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingsPage(widget.profile, widget.profiles)));
            },
            icon: Icon(
              Icons.menu,
              size: 33, color: kPrimaryColor, //kPrimaryColor
            ),
          )
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.hello},",
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: 18),
                      ),
                      Text(
                        widget.profile.name,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 42,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          style: TextStyle(color: kPrimaryColor),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 30),
                            filled: true,
                            fillColor: Colors.blueGrey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            hintText: AppLocalizations.of(context)!.searchStory,
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                            suffixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          AppLocalizations.of(context)!.recentlyPlayed,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                _buildRecentlyPlayed(context),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                        child: Text(
                          AppLocalizations.of(context)!.myStories,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      _buildStoriesList(context),
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
