import "dart:math";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/common/models/story.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/profiles/utils/profile_image_selector.dart";
import "package:taletime/state/profile_state.dart";

class AddSharedStory extends StatefulWidget {
  const AddSharedStory({super.key, required this.story});

  final Story story;

  @override
  State<StatefulWidget> createState() => AddSharedStoryState();
}

class AddSharedStoryState extends State<AddSharedStory> {
  bool _isLoading = true;

  bool _success = false;
  String _message = "";

  @override
  void initState() {
    super.initState();
    print("Adding story to profile...");

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        _success = false;
        _message = "Erfolgreich";
      });
    });
  }

  Widget _buildSuccessMessage(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = min(screenHeight, screenWidth) * 0.3;

    return Column(
      children: [
        Icon(
          _success ? Icons.check : Icons.close,
          color: _success ? Colors.teal.shade600 : Colors.redAccent,
          size: iconSize,
        ),
        const SizedBox(
          height: 12,
        ),
        Text(_message),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileState>(context).profile;

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Image(
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          image: widget.story.imageUrl != null
                              ? NetworkImage(widget.story.imageUrl!)
                              : const AssetImage("assets/logo.png")
                                  as ImageProvider<Object>,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              child: Text(
                                widget.story.title ??
                                    AppLocalizations.of(context)!.noTitle,
                                softWrap: true,
                                style: const TextStyle(
                                    color: Colors.teal,
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              child: Text(
                                widget.story.author ??
                                    AppLocalizations.of(context)!.noName,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _buildSuccessMessage(context),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: profile == null
                              ? const SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ProfileImageSelector.selectFile(
                                        profile.image, 25),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(profile.name),
                                  ],
                                ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                              AppLocalizations.of(context)!.continueToProfile),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
