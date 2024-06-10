import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/profiles/utils/profile_image_selector.dart";
import "package:taletime/profiles/utils/profile_service.dart";
import "package:taletime/state/user_state.dart";
import "../../common utils/constants.dart";
import "../../common utils/decoration_util.dart";
import "../../common utils/theme_provider.dart";
import "../../internationalization/locale_provider.dart";
import "../../internationalization/localizations_ext.dart";
import "../models/profile_model.dart";
import "../screens/profiles_page.dart";

class CreateEditProfile extends StatefulWidget {
  const CreateEditProfile({super.key, required this.profile});

  final Profile profile;

  @override
  State<StatefulWidget> createState() {
    return _CreateEditProfileState();
  }
}

class _CreateEditProfileState extends State<CreateEditProfile> {
  final logger = TaleTimeLogger.getLogger();
  late final String name;
  late final String image;
  late final String title;
  late final Profile profile;
  final textEditingController = TextEditingController();

  late String profileImage = widget.profile.image;

  late ProfileType? selectedItem = widget.profile.title;

  _CreateEditProfileState();

  @override
  void initState() {
    super.initState();
  }

  String updateProfileImage(String image) {
    setState(() {
      profileImage = image;
    });
    return profileImage;
  }

  void updateProfileInDB(DocumentReference<Profile> profile, String name,
      String image, String title) {
    ProfileService.updateProfile(profile, image, name, title);
  }

  void reset() {
    profileImage = "";
    selectedItem = ProfileType.listener;
    textEditingController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final String actionButtonTitle;
    if (widget.profile.id != "") {
      actionButtonTitle = AppLocalizations.of(context)!.updateProfile;
    } else {
      actionButtonTitle = AppLocalizations.of(context)!.addProfile;
    }
    var otherImages =
        profileImages.where((element) => !(element == profileImage)).toList();
    final languageProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    textEditingController.text = textEditingController.text == ""
        ? widget.profile.name
        : textEditingController.text;

    DocumentReference<Profile>? profileRef;

    if (widget.profile.id.isNotEmpty) {
      profileRef = Provider.of<UserState>(context).profilesRef?.doc(widget.profile.id);
    } else {
      profileRef = null;
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
                        itemCount: otherImages.length,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    updateProfileImage(otherImages[i]);
                                  });
                                },
                                child: ProfileImageSelector.selectFile(
                                  otherImages[i],
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
                              return AppLocalizations.of(context)!
                                  .fillBlankSpace;
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
                          value: selectedItem?.name,
                          items: ProfileType.values
                              .map((item) => DropdownMenuItem<String>(
                                    value: item.name,
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (item) => setState(() {
                                selectedItem = ProfileType.fromString(item);
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
                          if (widget.profile.id != "") {
                            ProfileService.updateProfile(
                                profileRef!, image, name, title);
                            reset();
                            Navigator.of(context).pop();
                          } else {
                            ProfileService.addProfile(
                                Provider.of<UserState>(context, listen: false).profilesRef!,
                                image,
                                name,
                                title,
                                languageProvider.locale.toString(),
                                !themeProvider.isDarkMode);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfilesPage()));
                          }
                        },
                        child: Text(
                          actionButtonTitle,
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
