/// The [create_story] class allows for the user to create a new story with [insert title] and [insert tags] and [add photo] .

///with the button you can create the story and put it on the page

///The list of tags is displayed here

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:taletime/common%20utils/constants.dart';
import 'package:taletime/storyteller/utils/record_class.dart';
import 'package:taletime/login%20and%20registration/utils/validation_util.dart';
import '../../common utils/decoration_util.dart';
import 'my_record_story.dart';

class CreateStory extends StatefulWidget {
  final CollectionReference storiesCollection;

  CreateStory(this.storiesCollection, {Key? key}) : super(key: key);

  @override
  State<CreateStory> createState() => _CreateStoryState(this.storiesCollection);
}

class _CreateStoryState extends State<CreateStory> {
  final CollectionReference storiesCollection;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  _CreateStoryState(this.storiesCollection);

  String? title;
  final List<ChipModel> _chipList = [];
  Image? image;
  File? imageFile;

  ///with the method the photo is fetched from the Galary and stored in filePickerResult.
  /// then you can get the photo with the Path
  @override
  void initState() {
    super.initState();
    image = Image.network(storyImagePlaceholder);
    imageFile = File("");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _deleteChip(String id) {
    setState(() {
      _chipList.removeWhere((element) => element.id == id);
    });
  }

  void getImageFromGallery() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      String? name = filePickerResult.files.single.path;
      File file = File(name!);
      setState(() {
        image = Image.file(file);
        imageFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "Create Story",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    ///enter the title the Story
                    child: TextFormField(
                      controller: _titleController,
                      decoration: Decorations().textInputDecoration(
                        "Title",
                        "Enter the Title for your Story",
                        Icon(Icons.title),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (title) =>
                          ValidationUtil().validateTitle(title, context),
                    ),
                    decoration: Decorations().inputBoxDecorationShaddow(),
                  ),
                  SizedBox(height: 25),
                  Container(
                    ///enter the Tags the Story
                    child: TextFormField(
                      controller: _tagController,
                      decoration: Decorations().textInputDecoration(
                          "Tag",
                          "Enter a Tag (Optional)",
                          Icon(Icons.tag),
                          IconButton(
                              onPressed: () {
                                if (_tagController.text.isNotEmpty) {
                                  setState(() {
                                    _chipList.add(ChipModel(
                                        id: DateTime.now().toString(),
                                        name: _tagController.text));
                                    _tagController.text = '';
                                  });
                                }
                              },
                              icon: Icon(Icons.arrow_circle_right_sharp))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
          Wrap(
            spacing: 10,
            children: _chipList
                .map((chip) => Chip(
                      label: Text(chip.name),
                      backgroundColor: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      onDeleted: () => _deleteChip(chip
                          .id), // call delete function by passing click chip id
                    ))
                .toList(),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 14,
              child: ElevatedButton(
                style: elevatedButtonDefaultStyle(),
                onPressed: () {
                  getImageFromGallery();
                },
                //here is the photo from the Gallery
                child: Text("Upload Image",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Container(
            height: 200,
            width: 200,
            child: Image(image: image!.image),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 14,
                width: double.infinity,
                child: ElevatedButton(
                    style: elevatedButtonDefaultStyle(),
                    onPressed: () {
                      final isValidForm = _formKey.currentState!.validate();
                      _chipList.forEach((element) {
                        print(element.name);
                      });
                      if (isValidForm) {
                        final myStory =
                            Story(_titleController.text, _chipList, image);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyRecordStory(
                                _titleController.text,
                                imageFile!,
                                storiesCollection),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 24),
                    )),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class ChipModel {
  final String id;
  final String name;
  ChipModel({required this.id, required this.name});
}
