import 'dart:math';
import 'package:flutter/material.dart';
import 'package:taletime/screens/record_story.dart';
import 'package:taletime/utils/record_class.dart';
import 'package:taletime/utils/validation_util.dart';

import '../utils/decoration_util.dart';

class CreateStory extends StatefulWidget {
  @override
  State<CreateStory> createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  String? title;
  final List<ChipModel> _chipList = [];
  FileImage? image;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Decorations().appBarDecoration(
          title: "Create Story", context: context, automaticArrow: false),
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
                  SizedBox(height: 25),
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
          Text("Upload a Image",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 5,
            child: Image.network(
                "https://firebasestorage.googleapis.com/v0/b/taletime-2022.appspot.com/o/images%2Fplus.png?alt=media&token=14b35122-cade-4508-a54b-c7c5930b01a6",
                color: Colors.green),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 14,
                width: double.infinity,
                child: ElevatedButton(
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
                            builder: (context) => RecordStory(myStory),
                          ),
                        );
                      }
                    },
                    child: Text("Continue")),
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
