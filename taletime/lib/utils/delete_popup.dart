import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants.dart';

class DeletePopup extends StatefulWidget {
  const DeletePopup({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DeletePopupState();
  }
}

class _DeletePopupState extends State<DeletePopup> {

  void onSelected(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Delete story...",
                  style: TextStyle(color: kPrimaryColor),
                ),
                content:
                Text("Do you really want to delete this story?"),
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
      icon: Icon(Icons.delete, color: Colors.white, size: 21,),
      onPressed: () {
        onSelected(context);
      },
    );
  }
}