import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:taletime/screens/create_story.dart';

class Story {
  /// Instanzvariablen
  String? title;
  late List<ChipModel> tags;
  FileImage? image;

  Story(String? title, List<ChipModel> tags, FileImage? image) {
    this.title = title;
    this.tags = tags;
    this.image = image;
  }

  String? getTitle() {
    return this.title;
  }

  FileImage? getImage() {
    return this.image;
  }
}

class Record {
  /// Instanzvariablen
  Story? story;
  List<File>? audios;

  Record(Story story, List<File> audios) {
    this.story = story;
    this.audios = audios;
  }
}
