import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart" as firebase_auth;
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/decoration_util.dart";
import "package:taletime/common/models/tale_time_user.dart";
import "package:taletime/login%20and%20registration/screens/welcome.dart";
import "package:taletime/profiles/models/profile_model.dart";
import "package:taletime/profiles/utils/create_edit_profile.dart";
import "package:taletime/state/user_state.dart";

import "../../internationalization/localizations_ext.dart";
import "../../login and registration/utils/authentification_util.dart";
import "../utils/profile_list.dart";

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({super.key, this.redirectTo});

  final Widget? redirectTo;

  @override
  State<StatefulWidget> createState() {
    return _ProfilesPageState();
  }
}

class _ProfilesPageState extends State<ProfilesPage> {
  _ProfilesPageState();

  CollectionReference<TaleTimeUser> users =
      FirebaseFirestore.instance.collection("users").withConverter(
            fromFirestore: (snap, _) => TaleTimeUser.fromDocumentSnapshot(snap),
            toFirestore: (snap, _) => snap.toFirebase(),
          ); // users collection
  final firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  int cflex = 7;

  @override
  void initState() {
    super.initState();
    //getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Decorations().confirmationDialog(
                      AppLocalizations.of(context)!.loggingOut,
                      AppLocalizations.of(context)!.confirmLogout,
                      context, () async {
                    AuthentificationUtil(auth: auth).signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ),
                      (route) => false,
                    );
                  });
                },
              );
            }),
        title: Text(
          AppLocalizations.of(context)!.myProfiles,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => CreateEditProfile(
                            profile: defaultProfile,
                          )));
                },
                icon: const Icon(
                  Icons.person_add,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Column(
          children: [
            Expanded(
              flex: cflex,
              child: Consumer<UserState>(
                builder: (context, userState, _) {
                  List<Profile>? profiles = userState.profiles;

                  if (profiles != null) {
                    return ListView.builder(
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final Profile profile = profiles[index];
                        return ProfileList(
                          profile: profile,
                          redirectTo: widget.redirectTo,
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
