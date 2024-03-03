import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common/models/story.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/login%20and%20registration/screens/login.dart";
import "package:taletime/profiles/models/profile_model.dart";
import "package:taletime/profiles/screens/profiles_page.dart";
import "package:taletime/profiles/utils/profile_image_selector.dart";
import "package:taletime/share/screens/add_shared_story.dart";
import "package:taletime/state/profile_state.dart";
import "package:taletime/state/user_state.dart";

class SharedStoryArguments {
  SharedStoryArguments(this.storyId);

  final String? storyId;
}

class SharedStory extends StatefulWidget {
  const SharedStory({super.key});

  @override
  State<StatefulWidget> createState() => SharedStoryState();
}

class SharedStoryState extends State<SharedStory> {
  String? _storyId;
  DocumentReference<Story>? _storyRef;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _storyId = GoRouterState.of(context).uri.queryParameters["storyId"];

        _storyRef = FirebaseFirestore.instance
            .doc("allStories/$_storyId")
            .withConverter(
              fromFirestore: (snap, _) => Story.fromDocumentSnapshot(snap),
              toFirestore: (snap, _) => snap.toFirebase(),
            );
      });
    });
  }

  Widget _buildStoryMetadata(BuildContext context, Story? story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final imageSize = min(screenHeight, screenWidth) * 0.6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.transparent,
          ),
          child: Image(
              fit: BoxFit.cover,
              image: story?.imageUrl != null
                  ? NetworkImage(story!.imageUrl!)
                  : const AssetImage("assets/logo.png")
                      as ImageProvider<Object>),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            story?.title ?? AppLocalizations.of(context)!.noTitle,
            softWrap: true,
            style: const TextStyle(
                color: Colors.teal,
                fontSize: 21.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            story?.author ?? AppLocalizations.of(context)!.noName,
            softWrap: true,
            style: const TextStyle(
              color: Colors.teal,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddToProfile(BuildContext context, Story? story) {
    renderWidget(
        {required Widget profile, Widget? error, void Function()? btnClick}) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: profile,
          ),
          error ?? const SizedBox(),
          ElevatedButton(
            style: elevatedButtonDefaultStyle(),
            onPressed: btnClick,
            child: Text(AppLocalizations.of(context)!.addToProfile),
          ),
        ],
      );
    }

    // Test if logged in
    if (Provider.of<UserState>(context).user == null) {
      return renderWidget(
        profile: Text(AppLocalizations.of(context)!.notLoggedIn),
        btnClick: story == null
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(
                      redirectTo: AddSharedStory(
                        story: story,
                      ),
                    ),
                  ),
                );
              },
      );
    }

    // Test if profile selected
    final profile = Provider.of<ProfileState>(context).profile;
    if (profile == null) {
      return renderWidget(
        profile: Text(AppLocalizations.of(context)!.noProfileSelected),
        btnClick: story == null
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilesPage(
                      redirectTo: AddSharedStory(
                        story: story,
                      ),
                    ),
                  ),
                );
              },
      );
    }

    // Build profile preview
    final profileWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProfileImageSelector.selectFile(profile.image, 25),
        const SizedBox(
          width: 8,
        ),
        Text(profile.name),
      ],
    );

    // Test if story teller
    if (profile.title == ProfileType.storyteller) {
      return renderWidget(
        profile: profileWidget,
        error: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.cantAddToStoryTeller,
            softWrap: true,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }

    return renderWidget(
      profile: profileWidget,
      btnClick: story == null
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSharedStory(
                    story: story,
                  ),
                ),
              );
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sharedStory),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: StreamBuilder(
                  stream: _storyRef?.snapshots(),
                  builder: (context, storySnapshot) {
                    var story = storySnapshot.data?.data();

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildStoryMetadata(context, story),
                        _buildAddToProfile(context, story),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
