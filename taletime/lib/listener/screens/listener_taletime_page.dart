import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

import "../../common utils/constants.dart";
import "../../common utils/decoration_util.dart";
import "../../common/models/story.dart";
import "../../common/widgets/story_list_item.dart";
import "../../internationalization/localizations_ext.dart";

class ListenerTaletimePage<T extends Story> extends StatefulWidget {
  const ListenerTaletimePage({
    super.key,
    required this.docs,
    required this.buttonsBuilder,
    required this.title,
  });

  final String title;
  final List<QueryDocumentSnapshot<T>> docs;
  final List<StoryActionButton> Function(QueryDocumentSnapshot<T>)
      buttonsBuilder;

  @override
  State<ListenerTaletimePage<T>> createState() => _ListenerTaletimePageState();
}

class _ListenerTaletimePageState<T extends Story>
    extends State<ListenerTaletimePage<T>> {
  String searchString = "";

  QueryDocumentSnapshot<T> getReferenceOfStory(Story story) {
    return widget.docs.where((element) => element.id == story.id).first;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.docs.isEmpty) {
      return Decorations().noRecentContent(
          AppLocalizations.of(context)!.noStoriesAvailable, "recentStories");
    }
    List<T> storiesDocumentSnapshot;
    if (searchString.trim().isNotEmpty) {
      storiesDocumentSnapshot = widget.docs
          .map((e) => e.data())
          .where((element) =>
              element.title
                  ?.toLowerCase()
                  .contains(searchString.toLowerCase()) ??
              false)
          .toList();
    } else {
      storiesDocumentSnapshot = widget.docs.map((e) => e.data()).toList();
    }

    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarOpacity: 0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              size: 23,
              color: kPrimaryColor,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: 42,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchString = value;
                    });
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
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 18),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                primary: false,
                padding: const EdgeInsets.all(8),
                itemCount: storiesDocumentSnapshot.length,
                itemBuilder: (k, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        StoryListItem(
                          key: Key(storiesDocumentSnapshot[i].id),
                          buttons: widget.buttonsBuilder(
                              getReferenceOfStory(storiesDocumentSnapshot[i])),
                          story: storiesDocumentSnapshot[i],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
