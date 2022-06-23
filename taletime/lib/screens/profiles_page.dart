import 'package:flutter/material.dart';
import 'package:taletime/utils/add_profile.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/profile_list.dart';
import '../utils/decoration_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilesPageState();
  }
}

class _ProfilesPageState extends State<ProfilesPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('profiles');

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
        //backgroundColor: HexColor("#fafafa"),
        leading: IconButton(
            icon: Icon(Icons.logout, //color: kPrimaryColor
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Decorations().confirmDialog(
                      AppLocalizations.of(context)!.loggingOut,
                      AppLocalizations.of(context)!.confirmLogout,
                      context);
                },
              );
            }),
        title: Text(
          AppLocalizations.of(context)!.myProfiles,
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => AddProfile()));
                },
                icon: Icon(Icons.person_add, 
                //color: kPrimaryColor
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
                stream: users.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                  if(streamSnapshot.hasData){
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                        return ProfileList(documentSnapshot);
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
