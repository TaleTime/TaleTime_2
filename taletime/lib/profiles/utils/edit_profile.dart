import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/profiles/utils/profile_image_selector.dart";
import "package:taletime/profiles/utils/profile_service.dart";
import "../../common utils/constants.dart";
import "../../common utils/decoration_util.dart";
import "../../internationalization/localizations_ext.dart";
import "../models/profile_model.dart";

class EditProfile extends StatefulWidget {
  final CollectionReference profiles;
  final Profile profile;
  final DocumentReference<Profile> profileRef;

  const EditProfile(this.profiles, this.profile, this.profileRef, {super.key});

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
  final List<String> items = ["Listener", "Story-teller"];
  final textEditingController = TextEditingController();

  late String profileImage = widget.profile.image;

  late String? selectedItem = widget.profile.title;

  _EditProfileState();

  @override
  Widget build(BuildContext context) {
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

    void updateprofile(DocumentReference<Profile> profile, String name,
        String image, String title) {
      ProfileService.updateProfile(profile, image, name, title);
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
        title: Text(
          AppLocalizations.of(context)!.editProfile,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    child: ProfileImageSelector.selectFile(profileImage, 150),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: profileImages.length,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    updateProfile(i);
                                  });
                                },
                                child: ProfileImageSelector.selectFile(
                                  profileImages[i],
                                  100,
                                )),
                          );
                        }),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: Decorations().inputBoxDecorationShaddow(),
                        child: TextFormField(
                          controller: textEditingController,
                          decoration: Decorations().textInputDecoration(
                              AppLocalizations.of(context)!.profileName,
                              AppLocalizations.of(context)!.enterProfile),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)!.fillBlankSpace;
                            }
                            return null;
                          },
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: InputDecoration(
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(color: kPrimaryColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(color: kPrimaryColor)),
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
                    ],
                  ),
                  SizedBox(
                    height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: elevatedButtonDefaultStyle(),
                        onPressed: () {
                          name = textEditingController.text;
                          image = profileImage;
                          title = selectedItem.toString();
                          updateprofile(widget.profileRef, name, image, title);
                          reset();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          //AppLocalizations.of(context)!.addProfile,
                          AppLocalizations.of(context)!.updateProfile,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
