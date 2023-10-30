import "package:flutter/material.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "../../internationalization/localizations_ext.dart";
import "../../common utils/constants.dart";

class IconContextDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String id;
  final stories;

  const IconContextDialog(
      this.title, this.subtitle, this.icon, this.id, this.stories,
      {super.key});

  @override
  State<StatefulWidget> createState() {
    return _IconContextDialogState();
  }
}

class _IconContextDialogState extends State<IconContextDialog> {
  final logger = TaleTimeLogger.getLogger();

  _IconContextDialogState();

  bool isStoryDeleted = false;

  Future<void> deleteStory(String id) async {
    await widget.stories.doc(id).delete().then((value) {
      setState(() {
        isStoryDeleted = true;
      });
      logger.v("Story Deleted!");
    }).catchError((error) => logger.e("Failed to delete story: $error"));
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
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () async {
                  //story delete action
                  await deleteStory(widget.id);
                  Navigator.of(context).pop();
                  setState(() {
                    isStoryDeleted = false;
                  });
                },
                child: Text(
                  AppLocalizations.of(context)!.yes,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
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
    if (isStoryDeleted) {
      return Text(AppLocalizations.of(context)!.storyDeleted);
    } else {
      return IconButton(
        icon: Icon(
          widget.icon,
          color: Colors.white,
          size: 21,
        ),
        onPressed: () {
          onSelected(context, widget.title, widget.subtitle);
        },
      );
    }
  }
}
