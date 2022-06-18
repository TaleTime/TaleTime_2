import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileColumn {
  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.deleteProfile,
                  style: TextStyle(color: kPrimaryColor),
                ),
                content:
                     Text(AppLocalizations.of(context)!.confirmProfileDeletion),
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
                      /*cards.removeLast();
                      setState(() {});*/
                      Navigator.of(context).pop();
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
        break;
    }
  }

  Column myColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: kPrimaryColor),
            textTheme: const TextTheme().apply(bodyColor: Colors.white),
          ),
          child: PopupMenuButton<int>(
            color: Colors.white,
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.edit),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.delete),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
