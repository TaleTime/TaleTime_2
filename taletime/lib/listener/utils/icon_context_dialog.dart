import "package:flutter/material.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";

import "../../common utils/constants.dart";
import "../../internationalization/localizations_ext.dart";

class IconContextDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String id;
  final stories;

  const IconContextDialog(
      this.title, this.subtitle, this.icon, this.id, this.stories,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IconContextDialogState();
  }
}

class _IconContextDialogState extends State<IconContextDialog> {
  final logger = TaleTimeLogger.getLogger();

  Future<void> deleteUser(String id) {
    return widget.stories
        .doc(id)
        .delete()
        .then((value) => logger.v("User Deleted"))
        .catchError((error) => logger.e("Failed to delete user: $error"));
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
                onPressed: () {
                  setState(() {
                    deleteUser(widget.id);
                    Navigator.of(context).pop();
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
