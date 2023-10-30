import "dart:io";
import "dart:typed_data";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:file_picker/file_picker.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "../../common utils/constants.dart";
import "../../common utils/decoration_util.dart";

class EditStory extends StatefulWidget {
  final CollectionReference storiesCollection;
  final DocumentSnapshot story;

  const EditStory(this.storiesCollection, this.story, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _EditStoryState();
  }
}

class _EditStoryState extends State<EditStory> {
  final logger = TaleTimeLogger.getLogger();
  late final String author;
  late final String image;
  late final String title;

  _EditStoryState();

  final textEditingControllerAuthor = TextEditingController();
  final textEditingControllerTitle = TextEditingController();
  late final String storyImage;

  Uint8List? imageByte;

  String? url;

  Image? myImage;

  @override
  void initState() {
    super.initState();
    myImage = widget.story["image"] == ""
        ? Image.network(storyImagePlaceholder)
        : Image.network(widget.story["image"]);
    url = "";
  }

  void getImageFromGallery() async {
    var ref = FirebaseStorage.instance.ref().child("images");
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      String? image = filePickerResult.files.first.path;
      String? name = filePickerResult.files.first.name;
      File file = File(image!);
      // Upload file
      await ref.child(name).putFile(file);
      String myUrl = await ref.child(name).getDownloadURL();
      setState(() {
        widget.storiesCollection
            .doc(widget.story["id"])
            .update({"image": myUrl})
            .then((value) => logger.v("story Updated"))
            .catchError((error) => logger.e("Failed to update story: $error"));
        myImage = Image.file(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    //storyImage = story["image"] == "" ? storyImagePlaceholder : story["image"];

    textEditingControllerAuthor.text = textEditingControllerAuthor.text == ""
        ? widget.story["author"]
        : textEditingControllerAuthor.text;

    textEditingControllerTitle.text = textEditingControllerTitle.text == ""
        ? widget.story["title"]
        : textEditingControllerTitle.text;

    Future<void> updateStory(
        String storyId, String author, String image, String title) {
      return widget.storiesCollection
          .doc(storyId)
          .update({"author": author, "title": title})
          .then((value) => logger.v("story Updated"))
          .catchError((error) => logger.e("Failed to update story: $error"));
    }

    void reset() {
      //storyImage = "";
      textEditingControllerTitle.text = "";
      textEditingControllerAuthor.text = "";
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
          AppLocalizations.of(context)!.editStory,
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
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          width: 170.0,
                          height: 170.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill, image: myImage!.image),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child:  Text(AppLocalizations.of(context)!.updateImage,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  iconSize: 50,
                                  onPressed: () {
                                    setState(() {
                                      getImageFromGallery();
                                    });
                                  },
                                  icon: const Icon(Icons.add, size: 50),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: Decorations().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: textEditingControllerAuthor,
                            decoration: Decorations().textInputDecoration(
                                AppLocalizations.of(context)!.authorsName, AppLocalizations.of(context)!.typeInNewName),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return AppLocalizations.of(context)!.fillBlankSpace;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                            decoration:
                                Decorations().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: textEditingControllerTitle,
                              decoration: Decorations().textInputDecoration(
                                  AppLocalizations.of(context)!.storysTitle, AppLocalizations.of(context)!.typeInNewTitle),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return AppLocalizations.of(context)!.fillBlankSpace;
                                }
                                return null;
                              },
                            )),
                        const SizedBox(height: 50),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 15,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                author = textEditingControllerAuthor.text;
                                image = url!;
                                title = textEditingControllerTitle.text;
                                updateStory(widget.story["id"], author, image, title);
                                reset();
                              },
                              child:  Text(
                                AppLocalizations.of(context)!.updateStory,
                                style: const TextStyle(
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
