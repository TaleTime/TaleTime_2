import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "../../common utils/constants.dart";
import "../../common utils/decoration_util.dart";
import "../../internationalization/localizations_ext.dart";
import "../models/profile_model.dart";

class EditProfile extends StatefulWidget {
  final CollectionReference profiles;
  final Profile profile;

  const EditProfile(this.profiles, this.profile, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  final logger = TaleTimeLogger.getLogger();
  late final String name;
  late final String image;
  late final String title;
  late CollectionReference profiles;
  late final Profile profile;

  final textEditingController = TextEditingController();

  late String profileImage = widget.profile.image;

  late String? selectedItem = widget.profile.title;

  _EditProfileState();

  @override
  Widget build(BuildContext context) {
    List<String> items = ["Listener", "Story-teller"];
    final formKey = GlobalKey<FormState>();

    textEditingController.text = textEditingController.text == ""
        ? widget.profile.name
        : textEditingController.text;

    String updateProfile(int index) {
      var image = profileImages[index];
      setState(() {
        profileImage = image;
      });
      return profileImage;
    }

    Future<void> updateprofile(
        String profileId, String name, String image, String title) {
      return widget.profiles
          .doc(profileId)
          .update({"image": image, "name": name, "title": title})
          .then((value) => logger.v("Profile Updated"))
          .catchError((error) => logger.e("Failed to update profile: $error"));
    }

    void reset() {
      profileImage = "";
      selectedItem = "";
      textEditingController.text = "";
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            reset();
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Edit Profile",
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
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 30),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 20,
                                offset: Offset(5, 5),
                              ),
                            ],
                          ),
                          child: Image.network(profileImage, height: 150),
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
                                                updateProfile(i);
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
                            controller: textEditingController,
                            decoration: Decorations().textInputDecoration(
                                AppLocalizations.of(context)!.profileName,
                                AppLocalizations.of(context)!.enterProfile),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please fill in the blank space";
                              }
                              return null;
                            },
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
                              value: selectedItem,
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (item) => setState(() {
                                    selectedItem = item;
                                  })),
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 15,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: elevatedButtonDefaultStyle(),
                              onPressed: () {
                                name = textEditingController.text;
                                image = profileImage;
                                title = selectedItem.toString();
                                updateprofile(
                                    widget.profile.id, name, image, title);
                                reset();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                //AppLocalizations.of(context)!.addProfile,
                                "Update Profile",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            )),
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
