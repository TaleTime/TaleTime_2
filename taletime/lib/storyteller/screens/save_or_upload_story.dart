//the [save_or_upload_story] class enables the user,
///to either save the story to storage in firebase or share the story with specific listeners or all listeners.
///It contains three functions save ,load,load all
library;

import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/decoration_util.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/profiles/models/profile_model.dart";
import "package:taletime/storyteller/utils/navbar_widget_storyteller.dart";
import "package:taletime/storyteller/utils/record_class.dart";
import "package:taletime/storyteller/utils/upload_util.dart";

class SaveOrUploadStory extends StatefulWidget {
  final RecordedStory myRecordedStory;
  final storiesCollection;
  final bool isSaved;
  const SaveOrUploadStory(
      this.myRecordedStory, this.storiesCollection, this.isSaved,
      {super.key});

  @override
  State<SaveOrUploadStory> createState() => _SaveOrUploadStoryState();
}

class _SaveOrUploadStoryState extends State<SaveOrUploadStory> {
  final logger = TaleTimeLogger.getLogger();
  bool isSaved = false;
  _SaveOrUploadStoryState();

  final FirebaseAuth auth = FirebaseAuth.instance;

  late String author;
  late String title;
  late File audioFile;
  late String audioPath;
  late File image;
  late String uId;
  late CollectionReference users;
  late CollectionReference<Profile> profiles;
  late Color? primarySave;
  late Color? primaryUpload;

  @override
  void initState() {
    super.initState();
    author = auth.currentUser!.displayName.toString();
    title = widget.myRecordedStory.story.getTitle();
    image = File(widget.myRecordedStory.story.imagePath);
    audioPath = widget.myRecordedStory.recording.getAudioPath();
    audioFile = File(audioPath);
    isSaved = widget.isSaved;

    uId = auth.currentUser!.uid;
    users = FirebaseFirestore.instance.collection("users");
    profiles = users.doc(uId).collection("profiles").withConverter(
          fromFirestore: (snap, _) => Profile.fromDocumentSnapshot(snap),
          toFirestore: (snap, _) => snap.toFirebase(),
        );
    primarySave = isSaved ? Colors.grey : kPrimaryColor;
    primaryUpload = !isSaved ? Colors.grey : kPrimaryColor;
  }

  void createStory(String title, File image, String author, File audio) async {
    var refImages = FirebaseStorage.instance.ref().child("images");
    var refAudios = FirebaseStorage.instance.ref().child("audios");
    String filePath = widget.myRecordedStory.recording.getAudioPath();
    String imagePath = "$author/$title.jpg";
    String fileString =
        filePath.substring(filePath.lastIndexOf("/"), filePath.length);
    await refImages.child(imagePath).putFile(image);
    await refAudios.child(fileString).putFile(audio);
    String myImageUrl = await refImages.child(imagePath).getDownloadURL();
    String myAudioUrl =
        ""; // await refAudios.child(fileString).getDownloadURL();

    setState(() {
      widget.storiesCollection.add({
        "rating": "2.5",
        "title": title,
        "author": author,
        "image": myImageUrl,
        "audio": myAudioUrl,
        "isLiked": false,
        "id": ""
      }).then((value) {
        logger.v("Story Added to RecordedStories");
        updateList(value.id, widget.storiesCollection);
      }).catchError((error) => logger.e("Failed to add story: $error"));
    });
  }

  Future<void> updateList(String storyId, stories) {
    return stories
        .doc(storyId)
        .update({"id": storyId})
        .then((value) => logger.v("List Updated"))
        .catchError((error) => logger.e("Failed to update List: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Decorations().appBarDecoration(
          title: AppLocalizations.of(context)!.saveUploadStory,
          context: context,
          automaticArrow: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
                child: Text(
              AppLocalizations.of(context)!.save,
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 15),
            )),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primarySave),
                onPressed: isSaved
                    ? null
                    : () {
                        createStory(title, image, author, audioFile);
                        setState(() {
                          isSaved = true;
                        });
                      },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.save,
                      size: 50,
                    ),
                    Text(AppLocalizations.of(context)!.saveStory)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
                child: Text(
              AppLocalizations.of(context)!.uploadStory,
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.height / 15),
            )),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryUpload),
                    onPressed: !isSaved
                        ? null

                        ///
                        /// Logic not working yet
                        ///
                        : () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Decorations().confirmationDialog(
                                    AppLocalizations.of(context)!
                                        .uploadingStory,
                                    AppLocalizations.of(context)!
                                        .uploadingStoryDescription,
                                    context,
                                    () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NavBarSpeaker()));
                                    },
                                  );
                                });
                          },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(
                          Icons.upload_rounded,
                          size: 50,
                        ),
                        Text(AppLocalizations.of(context)!
                            .shareOnlyWithUsersFromSameAccount)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryUpload),
                    onPressed: !isSaved
                        ? null
                        : () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Decorations().confirmationDialog(
                                      AppLocalizations.of(context)!
                                          .uploadingStory,
                                      AppLocalizations.of(context)!
                                          .shareWithEveryUserDescription,
                                      context, () async {
                                    var refImages = FirebaseStorage.instance
                                        .ref()
                                        .child("images");
                                    String myImageUrl = await refImages
                                        .child("$author/$title.jpg")
                                        .getDownloadURL();

                                    UploadUtil(widget.storiesCollection)
                                        .uploadStory(audioPath, author,
                                            myImageUrl, title, "2.5", false);

                                    if (!context.mounted) return;

                                    Navigator.of(context).pop();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NavBarSpeaker()));
                                  });
                                });
                          },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(
                          Icons.upload_rounded,
                          size: 50,
                        ),
                        Text(AppLocalizations.of(context)!.shareWithEveryUser)
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Visibility(
                visible: isSaved,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 13,
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                      style: elevatedButtonDefaultStyle(),
                      child: Text(AppLocalizations.of(context)!.continueStep),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavBarSpeaker()));
                      }),
                )),
          ],
        ),
      ),
    );
  }
}
