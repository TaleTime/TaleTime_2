
import 'package:flutter/material.dart';
import 'package:taletime/common%20utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/profiles/utils/edit_profile.dart';

class ProfileColumn extends StatefulWidget {
  final profile;
  final profiles;
  const ProfileColumn(this.profile, this.profiles, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileColumnState(this.profile, this.profiles);
  }
}

class _ProfileColumnState extends State<ProfileColumn> {
  //late final DocumentSnapshot profile;
  final profile;
  final profiles;

  _ProfileColumnState(this.profile, this.profiles);

  Future<void> deleteUser(id) {
    return profiles
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfile(profiles, profile)));
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
                    child: Text(
                      AppLocalizations.of(context)!.yes,
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor)),
                    onPressed: () {
                      setState(() {
                        deleteUser(profile["id"]);
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
                  Icon(
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
                  Icon(Icons.delete),
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
