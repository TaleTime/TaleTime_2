///the classe [add_profile] allows users to create a profile with name,image,title,language, and theme.

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/common%20utils/theme_provider.dart";
import "package:taletime/login%20and%20registration/utils/validation_util.dart";
import "../../internationalization/locale_provider.dart";
import "../screens/profiles_page.dart";
import "../../common utils/constants.dart";
import "../../common utils/decoration_util.dart";
import "../../internationalization/localizations_ext.dart";

class AddProfile extends StatefulWidget {
  final String uId;

  const AddProfile(this.uId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddProfileState(uId);
  }
}

class _AddProfileState extends State<AddProfile> {
  late String uId;
  final logger = TaleTimeLogger.getLogger();
  _AddProfileState(this.uId);

  late final String name;
  late final String image;
  late final String title;
  late final bool theme;
  late final String language;

  String profileImage = profileImages[4];

  String? selectedItem = "";

  final textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<String> items = ["Listener", "Story-teller"];

    final languageProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    CollectionReference users = FirebaseFirestore.instance.collection("users");

    CollectionReference profiles = users.doc(uId).collection("profiles");

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
          .update({"id": profileId})
          .then((value) => logger.v("User Updated | profileId: $profileId"))
          .catchError((error) => logger.e("Failed to update user: $error"));
    }

    Future<void> addUser(
        String image, String name, String title, String language, bool theme) {
      return profiles.add({
        "id": "",
        "image": image,
        "name": name,
        "title": title,
        "language": language,
        "theme": theme
      }).then((value) {
        logger.d("User Added");
        updateUser(value.id);
      }).catchError((error) => logger.e("Failed to set Id: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilesPage(uId)));
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.newProfile,
          style: const TextStyle(
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
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 30),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Image.network(profileImage, height: 150),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 120,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: -210,
                                right: 0,
                                child: SizedBox(
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
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          decoration: Decorations().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.visiblePassword,
                            controller: textEditingController,
                            decoration: Decorations().textInputDecoration(
                                AppLocalizations.of(context)!.profileName,
                                AppLocalizations.of(context)!.enterProfile),
                            validator: (val) =>
                                ValidationUtil().validateUserName(val, context),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
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
                        ),
                        const SizedBox(height: 50),
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
                                    builder: (context) => ProfilesPage(uId)));
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
