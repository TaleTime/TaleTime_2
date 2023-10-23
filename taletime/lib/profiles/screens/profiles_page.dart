import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:taletime/login%20and%20registration/screens/welcome.dart";
import "package:taletime/profiles/utils/add_profile.dart";
import "package:taletime/common%20utils/decoration_util.dart";
import "../../internationalization/localizations_ext.dart";
import "../../login and registration/utils/authentification_util.dart";
import "../utils/profile_list.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class ProfilesPage extends StatefulWidget {
  final String uId;

  const ProfilesPage(this.uId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilesPageState(uId);
  }
}

class _ProfilesPageState extends State<ProfilesPage> {
  late String uId;

  _ProfilesPageState(this.uId);

  CollectionReference users = FirebaseFirestore.instance.collection("users"); // users collection
  final FirebaseAuth auth = FirebaseAuth.instance;
  int cflex = 7;

  @override
  void initState() {
    super.initState();
    //getUser();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference profiles =
        users.doc(uId).collection("profiles"); //profiles of the created user as subcollection

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
                  return Decorations().confirmationDialog(AppLocalizations.of(context)!.loggingOut,
                      AppLocalizations.of(context)!.confirmLogout, context, () async {
                    AuthentificationUtil(auth: auth).signOut();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const WelcomePage()));
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
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) => AddProfile(uId)));
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
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[
                            index]; //documentSnapshot as a single profile in the profiles collections (using a snapshot we got this single profile object)
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
