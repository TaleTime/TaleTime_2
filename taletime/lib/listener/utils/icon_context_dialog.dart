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

  const IconContextDialog(this.title, this.subtitle, this.icon, this.id, this.stories, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IconContextDialogState(title, subtitle, icon, id, stories);
  }
}

class _IconContextDialogState extends State<IconContextDialog> {
  final logger = TaleTimeLogger.getLogger();
  final String title;
  final String subtitle;
  final IconData icon;
  final String id;
  final stories;

  _IconContextDialogState(this.title, this.subtitle, this.icon, this.id, this.stories);

  bool isStoryDeleted = false;

  /*Future<void> deleteUser(String id) {
    return stories
        .doc(id) //create document with custom id
        .delete()
        .then((value) => logger.v("User Deleted"))
        .catchError((error) => logger.e("Failed to delete user: $error"));
  }*/

  Future<void> deleteUser(String id) async {
    await stories.doc(id).delete().then((value) {
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
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () async {
                  //story delete action
                  await deleteUser(id);
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

  /*@override
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
  }*/

  @override
  Widget build(BuildContext context) {
    if (isStoryDeleted) {
      return const Text("Story Deleted");
    } else {
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
}
