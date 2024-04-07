/// The [create_story] class allows for the user to create a new story with [insert title] and [insert tags] and [add photo] .
library;

///with the button you can create the story and put it on the page

///The list of tags is displayed here

import "dart:io";
import "dart:math";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:logger/logger.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/internationalization/localizations_ext.dart";
import "package:taletime/login%20and%20registration/utils/validation_util.dart";
import "../../common utils/decoration_util.dart";
import "../utils/record_class.dart";
import "my_record_story.dart";
import "package:path/path.dart" as path;
import "../../common/models/story.dart";

class CreateStory extends StatefulWidget {
  final CollectionReference<Story>? storiesCollection;

  const CreateStory(this.storiesCollection, {super.key});

  @override
  State<CreateStory> createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  final logger = TaleTimeLogger.getLogger();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  _CreateStoryState();

  String? title;
  final List<ChipModel> _chipList = [];

  /// image that gets displayed after uploading an image from the gallery
  Image? image;

  ///
  late File imageFile;

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
      String currentDirectory = path.current;
      String absolutePath = path.join(currentDirectory, name);

      Logger loger = Logger();
      loger.v(path.normalize(absolutePath));
      // File file = File(name!);
      File file = File(path.normalize(absolutePath));
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
            AppLocalizations.of(context)!.createStory,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          )),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    ///enter the title the Story
                    decoration: Decorations().inputBoxDecorationShaddow(),

                    ///enter the title the Story
                    child: TextFormField(
                      controller: _titleController,
                      decoration: Decorations().textInputDecoration(
                        "Title",
                        "Enter the Title for your Story",
                        const Icon(Icons.title),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (title) =>
                          ValidationUtil().validateTitle(title, context),
                    ),
                  ),
                  const SizedBox(height: 25),

                  ///enter the Tags the Story
                  TextFormField(
                    controller: _tagController,
                    decoration: Decorations().textInputDecoration(
                        AppLocalizations.of(context)!.tag,
                        AppLocalizations.of(context)!.enterTag,
                        const Icon(Icons.tag),
                        IconButton(
                            onPressed: () {
                              if (_tagController.text.isNotEmpty) {
                                setState(() {
                                  _chipList.add(ChipModel(
                                      id: DateTime.now().toString(),
                                      name: _tagController.text));
                                  _tagController.text = "";
                                });
                              }
                            },
                            icon: const Icon(Icons.arrow_circle_right_sharp))),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
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
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 14,
              child: ElevatedButton(
                style: elevatedButtonDefaultStyle(),
                onPressed: () {
                  getImageFromGallery();
                },
                //here is the photo from the Gallery
                child: Text(AppLocalizations.of(context)!.uploadImage,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: Image(image: image!.image),
          ),
          const SizedBox(height: 50),
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
                      for (var element in _chipList) {
                        logger.v(element.name);
                      }
                      if (isValidForm) {
                        List<String> tags = ["test"];
                        final myStory = RecordStory(
                            _titleController.text, tags, imageFile.path);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyRecordStory(
                                  myStory, widget.storiesCollection)),
                        );
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.continueStep,
                      style: const TextStyle(fontSize: 24),
                    )),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
