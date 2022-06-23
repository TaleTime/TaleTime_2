import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/utils/edit_profile.dart';

class ProfileColumn extends StatefulWidget {
  final DocumentSnapshot profile;
  const ProfileColumn(this.profile, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileColumnState(this.profile);
  }
}

class _ProfileColumnState extends State<ProfileColumn> {

  late final DocumentSnapshot profile;

  CollectionReference users = FirebaseFirestore.instance.collection('profiles');

  _ProfileColumnState(this.profile);

  Future<void> deleteUser(id) {
    return users
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditProfile(users, profile)));
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
                      setState((){
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
                    Text(AppLocalizations.of(context)!.edit, style: TextStyle(color: kPrimaryColor),),
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
                    Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: kPrimaryColor)),
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
