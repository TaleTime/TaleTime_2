import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/profiles/utils/profile_service.dart";
import "../../internationalization/localizations_ext.dart";
import "package:taletime/profiles/utils/create_edit_profile.dart";

import "../models/profile_model.dart";

class ProfileColumn extends StatefulWidget {
  final Profile profile;
  final CollectionReference<Profile> profiles;
  final DocumentReference<Profile> profileRef;
  const ProfileColumn(this.profile, this.profiles, this.profileRef,
      {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileColumnState();
  }
}

class _ProfileColumnState extends State<ProfileColumn> {
  final logger = TaleTimeLogger.getLogger();

  _ProfileColumnState();

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfile(
                    widget.profile, widget.profileRef, widget.profiles, null)));
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
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor)),
                    onPressed: () {
                      setState(() {
                        ProfileService.deleteProfile(widget.profileRef);
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
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor)),
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
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PopupMenuButton<int>(
          onSelected: (item) => onSelected(context, item),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: [
                  const Icon(
                    Icons.edit,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.edit,
                  ),
                ],
              ),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Row(
                children: [
                  const Icon(Icons.delete),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.delete),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
