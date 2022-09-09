import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taletime/utils/theme_provider.dart';
import '../internationalization/locale_provider.dart';
import '../screens/profiles_page.dart';
import 'constants.dart';
import 'decoration_util.dart';

class AddProfile extends StatefulWidget {
  final String UID;

  const AddProfile(this.UID , {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddProfileState(this.UID);
  }
}

class _AddProfileState extends State<AddProfile> {

  late String UID;

  _AddProfileState(this.UID);

  late final String name;
  late final String image;
  late final String title;
  late final bool theme;
  late final String language;
  late final List recent = [
    /*{
      "rating": "",
      "title": "",
      "author": "",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "0"
    },{
      "rating": "4.6",
      "title": "Peace Life",
      "author": "Unknown Author",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "1"
    },
    {
      "rating": "3.5",
      "title": "The India Story",
      "author": "Bimal Jalal",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "2"
    },
    {
      "rating": "4.0",
      "title": "Listen to Your Heart: The London Adventure",
      "author": "Ruskin Bond",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "3"
    },
    {
      "rating": "3.9",
      "title": "INDO-PAK WAR 1971- Reminiscences of Air Warriors",
      "author": "Rajnath Singh",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "4"
    }*/
  ];
  late final List favorites = [
    /*{
      "rating": "",
      "title": "",
      "author": "",
      "image": "",
      "audio": "",
      "isLiked": true,
      "id": ""
    },*/
  ];
  late final List stories = [
    /*{
      "rating": "",
      "title": "",
      "author": "",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "0"
    },{
      "rating": "4.6",
      "title": "Peace Life",
      "author": "Unknown Author",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "1"
    },
    {
      "rating": "3.5",
      "title": "The India Story",
      "author": "Bimal Jalal",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "2"
    },
    {
      "rating": "4.0",
      "title": "Listen to Your Heart: The London Adventure",
      "author": "Ruskin Bond",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "3"
    },
    {
      "rating": "3.9",
      "title": "INDO-PAK WAR 1971- Reminiscences of Air Warriors",
      "author": "Rajnath Singh",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "4"
    }*/
  ];
  String profileImage = profileImages[4];

  String? selectedItem = "";

  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //List<String> items = [AppLocalizations.of(context)!.listener,AppLocalizations.of(context)!.storyteller];
    List<String> items = ["Listener","Story-teller"];
    final _formKey = GlobalKey<FormState>();
    final languageProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    //final languageeee = languageProvider.locale.toString();

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    CollectionReference profiles = users.doc(UID).collection("profiles");

    String updateImageProfile(int index) {
      var image = profileImages[index];
      setState((){
        profileImage = image;
      });
      return profileImage;
    }

    Future<void> updateUser(String profileId) {
      return profiles
          .doc(profileId)
          .update({'id': profileId})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    Future<void> addUser(String image, String name, String title, List favorites, List recent, List stories, String language, bool theme) {
      return profiles
          .add({
        'favorites': favorites,
        'id': "",
        'image': image,
        'name': name,
        'recent': recent,
        'stories': stories,
        'title': title,
        'language': language,
        'theme': theme
      })
          .then((value) {
        print("User Added");
        updateUser(value.id);
      })
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.teal.shade600,),
          onPressed: () async {
            await Navigator.push(
                context, MaterialPageRoute(builder: (context) => ProfilesPage(UID)));
          },
        ),
        title: Text(//AppLocalizations.of(context)!.newProfile,
          "New Profile",
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
                                                updateImageProfile(i);
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
                              value: selectedItem != "" ? selectedItem : items[0],
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
                            title = selectedItem.toString() != "" ? selectedItem.toString() : items[0].toString();
                            theme = !themeProvider.isDarkMode;
                            language = languageProvider.locale.toString();
                            addUser(image, name, title, favorites, recent, stories, language, theme);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilesPage(UID)));
                          },
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            //AppLocalizations.of(context)!.addProfile,
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
