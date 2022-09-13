import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  /// Variablen
  Story? myStory;
  String? title;
  List<String>? tags;
  FileImage? image;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Create Story"), automaticallyImplyLeading: false),
      body: Column(children: [
        SizedBox(height: 50),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Form(
            key: _formKey,
            child: Container(
                child: TextFormField(
                    controller: _titleController,
                    decoration: Decorations().textInputDecoration("Title",
                        "Enter the Title for your Story", Icon(Icons.title)),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (title) =>
                        ValidationUtil().validateTitle(title, context)),
                decoration: Decorations().inputBoxDecorationShaddow()),
          ),
        ),
        SizedBox(height: 100),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 14,
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  final isValidForm = _formKey.currentState!.validate();
                  if (isValidForm) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecordStory()));
                  }
                },
                child: Text("Continue")),
          ),
        )
      ]),
    );
  }
}
