
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../utils/profile_list.dart';
import '../widgets/input_widget.dart';

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

  ReadData() async {
    await DefaultAssetBundle.of(context).loadString("json/profiles.json").then((value) {
      setState(() {
        profiles = json.decode(value);
      });
    });
  }

  @override
  void initState(){
    super.initState();
    ReadData();
  }

  @override
  Widget build(BuildContext context)  {

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#fafafa"),
        leading: IconButton(
            icon: Icon(Icons.logout, color: Colors.teal.shade600),
            onPressed: () { showDialog(
              context: context,
              builder: (BuildContext context) {
                return Input().confirmDialog("Out-logging...",
                    "Do you really want to logout of your account?",
                    context);
              },
            );
            }
        ),
        title: Text("My Profiles",
          style: TextStyle(color: Colors.teal.shade600, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: (){},
                icon: Icon(Icons.person_add, color: Colors.teal.shade600),
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