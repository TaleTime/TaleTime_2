import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/profiles_page.dart';
import 'constants.dart';
import 'decoration_util.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddProfileState();
  }
}

class _AddProfileState extends State<AddProfile> {
  late final String name;
  late final String image;
  late final String title;
  late final List recent = [];
  late final List favorites = [];
  late final List stories = [];

  //AddProfile(this.name, this.title, this.image, this.stories, this.recent, this.favorites);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    CollectionReference users = FirebaseFirestore.instance.collection('profiles');

    List<String> items = ["Listener","Story-teller"];
    String? selectedItem = items[0];
    String profileImage = "";
    String profileImageUpdate = "";

    String updateProfile(int index) {
        profileImage = profileImages[index];
        print(index);
        print(profileImage);
        print(profileImages[index]);
        return profileImage;
    }

    Future getImage(int index) async{
      var image = await profileImages[index];
      setState((){
        profileImage = image;
      });
      print(index);
      print(profileImage);
      print(profileImages[index]);
    }

    Future<void> addUser() {
      return users
          .add({
        'favorites': favorites,
        'image': image,
        'name': name,
        'recent': recent,
        'stories': stories,
        'title': title
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.teal.shade600;
      }
      return Colors.teal.shade600;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.teal.shade600,),
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => ProfilesPage()),
                  (route) => false,
            );
          },
        ),
        title: Text("New Profile",
          style: TextStyle(color: Colors.teal.shade600, fontWeight: FontWeight.bold,),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 30),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                                  ],
                                ),
                                child: (profileImage != "") ? Image.network(profileImage, height: 150) : Image.network(profileImages[4], height: 150)
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40,),
                        Container(
                          height: 120,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: -210,
                                right: 0,
                                child: Container(
                                  height: 80,
                                  child: PageView.builder(
                                      controller: PageController(viewportFraction: 0.2),
                                      itemCount: profileImages.length,
                                      itemBuilder: (_,i)
                                      {
                                        return GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                getImage(i);
                                              });
                                            },
                                            child: Image.network(profileImages[i], height: 80,)
                                        );
                                      }),
                                ),
                              ),
                            ],

                          ),
                        ),
                        SizedBox(height: 40,),
                        Container(
                          child: TextFormField(
                            decoration: Decorations().textInputDecoration('UserName', 'Enter your username'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please fill in the blank space";
                              }
                              return null;
                            },
                          ),
                          decoration: Decorations().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          child: SizedBox(
                            width: 420,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                focusColor: kPrimaryColor,
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(color: kPrimaryColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(color: kPrimaryColor)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                labelStyle: TextStyle(
                                  color: kPrimaryColor,
                                ),
                              ),
                              value: selectedItem,
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item, style: TextStyle(fontSize: 18, color: kPrimaryColor),),
                              )).toList(),
                              onChanged: (item) => setState(() {selectedItem = item;})
                            ),
                          )
                        ),
                        SizedBox(height: 50),
                        MaterialButton(
                          minWidth: double.infinity,
                          height: MediaQuery.of(context).size.height / 15,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProfilesPage()));
                          },
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Add Profile",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
