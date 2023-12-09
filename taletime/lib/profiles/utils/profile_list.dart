import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/profiles/utils/profile_image_selector.dart";
import "package:taletime/storyteller/utils/navbar_widget_storyteller.dart";
import "package:taletime/profiles/utils/profile_column_widget.dart";
import "../../listener/utils/navbar_widget_listener.dart";
import "../models/profile_model.dart";

class ProfileList extends StatelessWidget {
  final Profile profile;
  final CollectionReference<Profile> profiles;
  final DocumentReference<Profile> profileRef;

  ProfileList(this.profile, this.profiles, this.profileRef, {super.key});

  @override
  Widget build(BuildContext context) {
    final profilee = ProfileColumn(profile, profiles, profileRef);
    return GestureDetector(
      onTap: () async {
        if (profile.title == "Listener") {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NavBarListener(profile, profiles)));
        } else {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NavBarSpeaker(profile, profiles)));
        }
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 120,
            child: Column(
              children: [
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: Colors.transparent,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                          ),
                          child: ProfileImageSelector.selectFile(profile.image),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                profile.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0)),
                              Row(
                                children: [
                                  Icon(
                                    Icons.linear_scale,
                                    color: Colors.teal.shade600,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    profile.title,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 7),
                        child: profilee,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
