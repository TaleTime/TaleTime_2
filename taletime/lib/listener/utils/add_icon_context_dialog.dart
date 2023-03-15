import "package:flutter/material.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "../../internationalization/localizations_ext.dart";
import "../../common utils/constants.dart";

class AddIconContextDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final storiesCollectionReference;
  final allStories;

  const AddIconContextDialog(
      this.title, this.subtitle, this.icon, this.storiesCollectionReference, this.allStories,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddIconContextDialogState(
        title, subtitle, icon, storiesCollectionReference, allStories);
  }
}

class _AddIconContextDialogState extends State<AddIconContextDialog> {
  final logger = TaleTimeLogger.getLogger();
  final String title;
  final String subtitle;
  final IconData icon;
  final storiesCollectionReference;
  final allStories;

  late final String newAudio;
  late final String newImage;
  late final String newTitle;
  late final bool newIsLiked;
  late final String newAuthor;
  late final String newRating;

  _AddIconContextDialogState(
      this.title, this.subtitle, this.icon, this.storiesCollectionReference, this.allStories);

  Future<void> updateStoryList(String storyId) {
    return storiesCollectionReference
        .doc(storyId)
        .update({"id": storyId})
        .then((value) => logger.v("List Updated"))
        .catchError((error) => logger.e("Failed to update List: $error"));
  }

  Future<void> addStory(
      String audio, String author, String image, String title, String rating, bool isLiked) {
    return storiesCollectionReference.add({
      "id": "",
      "image": image,
      "audio": audio,
      "title": title,
      "rating": rating,
      "author": author,
      "isLiked": isLiked
    }).then((value) {
      logger.v("Story Added to story list");
      updateStoryList(value.id);
    }).catchError((error) => logger.e("Failed to add story to story list: $error"));
  }

  void onSelected(BuildContext context, String title, String subtitle) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(color: kPrimaryColor),
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () {
                  setState(() {
                    newAudio = allStories["audio"];
                    newImage = allStories["image"];
                    newTitle = allStories["title"];
                    newIsLiked = false;
                    newAuthor = allStories["author"];
                    newRating = allStories["rating"];
                    addStory(newAudio, newAuthor, newImage, newTitle, newRating, newIsLiked);
                    Navigator.of(context).pop();
                  });
                },
                child: Text(
                  AppLocalizations.of(context)!.yes,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.no,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
        size: 21,
      ),
      onPressed: () {
        onSelected(context, title, subtitle);
      },
    );
  }
}
