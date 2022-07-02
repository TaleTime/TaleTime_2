import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants.dart';

class IconContextDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const IconContextDialog(this.title, this.subtitle, this.icon, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IconContextDialogState(this.title, this.subtitle, this.icon);
  }
}

class _IconContextDialogState extends State<IconContextDialog> {
  late final String title;
  late final String subtitle;
  late final IconData icon;

  _IconContextDialogState(this.title, this.subtitle, this.icon);

  void onSelected(BuildContext context, String title, String subtitle) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  title,
                  style: TextStyle(color: kPrimaryColor),
                ),
                content:
                Text(subtitle),
                actions: [
                  TextButton(
                    child:  Text(
                      AppLocalizations.of(context)!.yes,
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(kPrimaryColor)),
                    onPressed: () {
                      setState((){
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
                        backgroundColor:
                        MaterialStateProperty.all(kPrimaryColor)),
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
      icon: Icon(icon, color: Colors.white, size: 21,),
      onPressed: () {
        onSelected(context, title, subtitle);
      },
    );
  }
}