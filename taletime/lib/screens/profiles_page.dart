import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';

import '../utils/profile_list.dart';
import '../utils/decoration_util.dart';


class ProfilesPage extends StatefulWidget{
  const ProfilesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilesPageState();
  }
}

class _ProfilesPageState extends State<ProfilesPage>{

  late List profiles;
  int cflex = 7;

  readData() async {
    await DefaultAssetBundle.of(context).loadString("json/profiles.json").then((value) {
      setState(() {
        profiles = json.decode(value);
      });
    });
  }

  @override
  void initState(){
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context)  {

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#fafafa"),
        leading: IconButton(
            icon: Icon(Icons.logout, color: kPrimaryColor),
            onPressed: () { showDialog(
              context: context,
              builder: (BuildContext context) {
               return Decorations().confirmDialog("Logge aus...",
                      "Wollen Sie sich wirklich aus Ihrem Konto ausloggen?", context);
              },
            );
            }
        ),
        title: Text("Meine Profile",
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: (){},
                icon: Icon(Icons.person_add, color: kPrimaryColor),
              )
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Column(
          children: [
            Expanded(
              flex:cflex,
              child: ListView.builder(
                itemCount: profiles.length,
                itemBuilder: (context, index) => ProfileList(
                    profiles[index]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}