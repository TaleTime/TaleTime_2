import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/profiles_page.dart';
import 'constants.dart';
import 'decoration_util.dart';

class EditProfile extends StatefulWidget {

  final CollectionReference profiles;
  final DocumentSnapshot profile;

  const EditProfile(this.profiles, this.profile, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditProfileState(this.profiles, this.profile);
  }
}

class _EditProfileState extends State<EditProfile> {
  late final String name;
  late final String image;
  late final String title;
  late final CollectionReference profiles;
  late final DocumentSnapshot profile;

  final textEditingController = TextEditingController();

  late String profileImage = profile["image"];

  late String? selectedItem = profile["title"];

  _EditProfileState(this.profiles, this.profile);

  @override
  Widget build(BuildContext context) {
    //List<String> items = [AppLocalizations.of(context)!.listener,AppLocalizations.of(context)!.storyteller];
    List<String> items = ["Listener","Story-teller"];
    final _formKey = GlobalKey<FormState>();

    CollectionReference users = profiles;

    DocumentSnapshot user = profile;

    textEditingController.text = textEditingController.text == ""? user["name"] : textEditingController.text;

    String updateProfile(int index) {
      var image = profileImages[index];
      setState((){
        profileImage = image;
      });
      return profileImage;
    }

    Future<void> updateUser(String userId, String name, String image, String title) {
      return users
          .doc(userId)
          .update({
        'image': image,
        'name': name,
        'title': title})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    void reset(){
      profileImage = "";
      selectedItem = "";
      textEditingController.text = "";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.teal.shade600,),
          onPressed: (){
            reset();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Edit Profile",
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
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: Colors.teal.shade600,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                            ],
                          ),
                          child: Image.network(profileImage, height: 150),
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
                                                updateProfile(i);
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
                            controller: textEditingController,
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
                            name = textEditingController.text;
                            image = profileImage;
                            title = selectedItem.toString();
                            updateUser(user["id"], name, image,  title);
                            reset();
                            Navigator.of(context).pop();
                          },
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            //AppLocalizations.of(context)!.addProfile,
                            "Update Profile",
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
