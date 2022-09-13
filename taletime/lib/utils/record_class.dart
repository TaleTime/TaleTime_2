import 'dart:io';

import 'package:flutter/cupertino.dart';

class Story {
  /// Instanzvariablen
  String? title;
  List<String>? tags;
  FileImage? image;

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
