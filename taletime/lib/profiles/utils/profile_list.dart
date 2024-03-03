import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/profiles/utils/profile_column_widget.dart";
import "package:taletime/profiles/utils/profile_image_selector.dart";
import "package:taletime/state/profile_state.dart";
import "package:taletime/state/user_state.dart";
import "package:taletime/storyteller/utils/navbar_widget_storyteller.dart";

import "../../listener/utils/navbar_widget_listener.dart";
import "../models/profile_model.dart";

class ProfileList extends StatelessWidget {
  const ProfileList({required this.profile, super.key, this.redirectTo});

  final Profile profile;

  final Widget? redirectTo;

  @override
  Widget build(BuildContext context) {
    final profileColumn = ProfileColumn(
      profile: profile,
    );
    return GestureDetector(
      onTap: () async {
        var profiles =
            Provider.of<UserState>(context, listen: false).profilesRef;

        final profileState = Provider.of<ProfileState>(context, listen: false);

        profileState.profileRef = profiles!.doc(profile.id);

        if (redirectTo == null) {
          if (profile.title == ProfileType.listener) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NavBarListener(),
              ),
            );

            print('Logging out of profile...');
            profileState.profileRef = null;
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NavBarSpeaker(),
              ),
            );

            print('Logging out of profile...');
            profileState.profileRef = null;
          }
        } else {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => redirectTo!,
            ),
          );

          print('Logging out of profile...');
          profileState.profileRef = null;
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
                                    profile.title.name,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 7),
                        child: profileColumn,
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
