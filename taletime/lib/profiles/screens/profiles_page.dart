import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart" as firebase_auth;
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/decoration_util.dart";
import "package:taletime/common/models/tale_time_user.dart";
import "package:taletime/login%20and%20registration/screens/welcome.dart";
import "package:taletime/profiles/models/profile_model.dart";
import "package:taletime/profiles/utils/create_edit_profile.dart";

import "../../internationalization/localizations_ext.dart";
import "../../login and registration/utils/authentification_util.dart";
import "../utils/profile_list.dart";

class ProfilesPage extends StatefulWidget {
  final String uId;

  const ProfilesPage(this.uId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfilesPageState();
  }
}

class _ProfilesPageState extends State<ProfilesPage> {
  _ProfilesPageState();

  CollectionReference<TaleTimeUser> users =
      FirebaseFirestore.instance.collection("users")
          .withConverter(
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
    CollectionReference<Profile> profiles =
        users.doc(widget.uId).collection("profiles").withConverter(
              fromFirestore: (snap, _) => Profile.fromDocumentSnapshot(snap),
              toFirestore: (snap, _) => snap.toFirebase(),
            ); //profiles of the created user as subcollection

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomePage()));
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
                          defaultProfile, null, profiles, widget.uId)));
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
              child: StreamBuilder(
                stream: profiles.snapshots(),
                builder: (context, profilesSnapshots) {
                  if (profilesSnapshots.hasData) {
                    return ListView.builder(
                      itemCount: profilesSnapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        final Profile profile = profilesSnapshots
                            .data!.docs[index]
                            .data(); //documentSnapshot as a single profile in the profiles collections (using a snapshot we got this single profile object)
                        final DocumentReference<Profile> profileRef =
                            profilesSnapshots.data!.docs[index].reference;
                        return ProfileList(profile, profiles, profileRef);
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
