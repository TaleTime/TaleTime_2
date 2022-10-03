
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../common utils/constants.dart';
import '../../common utils/decoration_util.dart';

class EditStory extends StatefulWidget {
  final CollectionReference storiesCollection;
  final DocumentSnapshot story;

  const EditStory(this.storiesCollection, this.story, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditStoryState(this.storiesCollection, this.story);
  }
}

class _EditStoryState extends State<EditStory> {
  late final String author;
  late final String image;
  late final String title;
  final CollectionReference storiesCollection;
  final story;

  _EditStoryState(this.storiesCollection, this.story);

  final textEditingControllerAuthor = TextEditingController();
  final textEditingControllerTitle = TextEditingController();
  late final String storyImage;

  Uint8List? imageByte;

  File? _pickedImage;
  String? url;


  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    storyImage = story["image"] == "" ? storyImagePlaceholder : story["image"];

    textEditingControllerAuthor.text = textEditingControllerAuthor.text == ""
        ? story["author"]
        : textEditingControllerAuthor.text;

    textEditingControllerTitle.text = textEditingControllerTitle.text == ""
        ? story["title"]
        : textEditingControllerTitle.text;

    Future<void> uploadImage() async {
      var ref = FirebaseStorage.instance.ref().child("images");
      FilePickerResult? picked = await FilePicker.platform.pickFiles();
        if (picked != null) {
          File file = File(picked.files.single.path!);
          String fileName = picked.files.first.name;
          // Upload file
          await ref.child(fileName).putFile(file);
          url = await ref.getDownloadURL();
          print(url);
          setState(() {
            _pickedImage = file;
          });
        }
    }

    Future<void> updateStory(
        String storyId, String author, String image, String title) {
      return storiesCollection
          .doc(storyId)
          .update({'image': image, 'author': author, 'title': title})
          .then((value) => print("story Updated"))
          .catchError((error) => print("Failed to update story: $error"));
    }

    void reset() {
      storyImage = "";
      textEditingControllerTitle.text = "";
      textEditingControllerAuthor.text = "";
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            reset();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Edit story",
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
                        Container(
                            child: Container(
                                  width: 170.0,
                                  height: 170.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: _pickedImage == null
                                              ? (story["image"] == "" ? NetworkImage(storyImagePlaceholder) : NetworkImage(story["image"])) as ImageProvider
                                              : FileImage(_pickedImage!)
                                      )
                                  )
                            )
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text("Update Image",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  iconSize: 50,
                                  onPressed: () {
                                    uploadImage();
                                  },
                                  icon: const Icon(Icons.add, size: 50),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: textEditingControllerAuthor,
                            decoration: Decorations().textInputDecoration(
                                "Author's name", "Type in new name"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please fill in the blank space";
                              }
                              return null;
                            },
                          ),
                          decoration: Decorations().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            child: TextFormField(
                              controller: textEditingControllerTitle,
                              decoration: Decorations().textInputDecoration(
                                  "Story's Title", "Type in new title"),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please fill in the blank space";
                                }
                                return null;
                              },
                            ),
                            decoration:
                                Decorations().inputBoxDecorationShaddow()),
                        SizedBox(height: 50),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 15,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                author = textEditingControllerAuthor.text;
                                image = url!;
                                title = textEditingControllerTitle.text;
                                updateStory(story["id"], author, image, title);
                                reset();
                              },
                              child: Text(
                                "Update Story",
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
