import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/login%20and%20registration/screens/welcome.dart';
import 'package:taletime/profiles/utils/add_profile.dart';
import 'package:taletime/common%20utils/decoration_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../login and registration/utils/authentification_util.dart';
import '../utils/profile_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilesPage extends StatefulWidget {
  final String UID;

  const ProfilesPage(this.UID, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilesPageState(this.UID);
  }
}

class _ProfilesPageState extends State<ProfilesPage> {
  late String UID;

  _ProfilesPageState(this.UID);

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  int cflex = 7;

  @override
  void initState() {
    super.initState();
    //getUser();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference profiles = users.doc(UID).collection('profiles');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.logout,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Decorations().confirmationDialog(
                      AppLocalizations.of(context)!.loggingOut,
                      AppLocalizations.of(context)!.confirmLogout,
                      context, () {
                    AuthentificationUtil(auth: auth).signOut();
                    return const WelcomePage();
                  });
                },
              );
            }),
        title: Text(
          AppLocalizations.of(context)!.myProfiles,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AddProfile(UID)));
                },
                icon: Icon(
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
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return ProfileList(documentSnapshot, profiles);
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
