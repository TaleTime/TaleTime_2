import 'package:flutter/material.dart';
import '../../internationalization/localizations_ext.dart';
import '../../common utils/constants.dart';

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
    return _IconContextDialogState(
        this.title, this.subtitle, this.icon, this.id, this.stories);
  }
}

class _IconContextDialogState extends State<IconContextDialog> {
  final String title;
  final String subtitle;
  final IconData icon;
  final String id;
  final stories;

  _IconContextDialogState(
      this.title, this.subtitle, this.icon, this.id, this.stories);

  Future<void> deleteUser(String id) {
    return stories
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
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
                child: Text(
                  AppLocalizations.of(context)!.yes,
                  style: const TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () {
                  setState(() {
                    deleteUser(id);
                    Navigator.of(context).pop();
                  });
                },
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.no,
                  style: const TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
