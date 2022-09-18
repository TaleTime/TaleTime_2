import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taletime/utils/theme_provider.dart';
import 'package:taletime/utils/validation_util.dart';
import '../internationalization/locale_provider.dart';
import '../screens/profiles_page.dart';
import 'constants.dart';
import 'decoration_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddProfile extends StatefulWidget {
  final String UID;

  const AddProfile(this.UID, {Key? key}) : super(key: key);

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
   /* {
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
    },
    {
      "rating": "4.6",
      "title": "Peace Life",
      "author": "Unknown Author",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "1"
    }*/
  ];
  late final List favorites = [
    /*{
      "rating": "4.6",
      "title": "Peace Life",
      "author": "Unknown Author",
      "image": "",
      "audio": "",
      "isLiked": true,
      "id": "1"
    }*/
  ];
  late final List stories = [
   /* {
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
    },
    {
      "rating": "3.5",
      "title": "The India Story",
      "author": "Bimal Jalal",
      "image": "",
      "audio": "",
      "isLiked": false,
      "id": "2"
    }*/
  ];
  String profileImage = profileImages[4];

  String? selectedItem = "";

  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //List<String> items = [AppLocalizations.of(context)!.listener,AppLocalizations.of(context)!.storyteller];
    List<String> items = ["Listener", "Story-teller"];
    final _formKey = GlobalKey<FormState>();
    final languageProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    //final languageeee = languageProvider.locale.toString();

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    CollectionReference profiles = users.doc(UID).collection("profiles");

    String updateImageProfile(int index) {
      var image = profileImages[index];
      setState(() {
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

    Future<void> addUser(
        String image,
        String name,
        String title,
        String language,
        bool theme) {
      return profiles.add({
        'id': "",
        'image': image,
        'name': name,
        'title': title,
        'language': language,
        'theme': theme
      }).then((value) {
        print("User Added");
        updateUser(value.id);
        profiles.doc(value.id).collection('favoriteList').add({
          "rating": "4.6",
          "title": "Peace Life",
          "author": "Unknown Author",
          "image": "",
          "audio": "",
          "isLiked": true,
          "id": "1"
        });
        profiles.doc(value.id).collection('recentList').add({
          "rating": "4.6",
          "title": "Peace Life",
          "author": "Unknown Author",
          "image": "",
          "audio": "",
          "isLiked": false,
          "id": "1"
        });
        profiles.doc(value.id).collection('storiesList').add({
          "rating": "4.6",
          "title": "Peace Life",
          "author": "Unknown Author",
          "image": "",
          "audio": "",
          "isLiked": false,
          "id": "1"
        });
        // ignore: invalid_return_type_for_catch_error
      }).catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilesPage(UID)));
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.newProfile,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Image.network(profileImage, height: 150),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
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
                                      controller:
                                          PageController(viewportFraction: 0.2),
                                      itemCount: profileImages.length,
                                      itemBuilder: (_, i) {
                                        return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                updateImageProfile(i);
                                              });
                                            },
                                            child: Image.network(
                                              profileImages[i],
                                              height: 80,
                                            ));
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: TextFormField(
                            controller: textEditingController,
                            decoration: Decorations().textInputDecoration(
                                AppLocalizations.of(context)!.profileName,
                                AppLocalizations.of(context)!.enterProfile),
                            validator: (val) =>
                                ValidationUtil().validateUserName(val, context),
                          ),
                          decoration: Decorations().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            child: SizedBox(
                          width: 420,
                          child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide:
                                        BorderSide(color: kPrimaryColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide:
                                        BorderSide(color: kPrimaryColor)),
                              ),
                              value:
                                  selectedItem != "" ? selectedItem : items[0],
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: kPrimaryColor),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (item) => setState(() {
                                    selectedItem = item;
                                  })),
                        )),
                        SizedBox(height: 50),
                        MaterialButton(
                          minWidth: double.infinity,
                          height: MediaQuery.of(context).size.height / 15,
                          onPressed: () {
                            name = textEditingController.text;
                            image = profileImage;
                            title = selectedItem.toString() != ""
                                ? selectedItem.toString()
                                : items[0].toString();
                            theme = !themeProvider.isDarkMode;
                            language = languageProvider.locale.toString();
                            addUser(image, name, title, language, theme);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilesPage(UID)));
                          },
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            AppLocalizations.of(context)!.addProfile,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
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
