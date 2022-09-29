import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:taletime/screens/create_story.dart';

class Story {
  /// Instanzvariablen
  late String title;
  late List<ChipModel> tags;
  FileImage? image;

  Story(String title, List<ChipModel> tags, FileImage? image) {
    this.title = title;
    this.tags = tags;
    this.image = image;
  }

  Story.test(String title) {
    this.title = title;
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
  late String recordTitle;
  late Duration duration;
  late File audio;

  Record(String recordTitle, Duration duration, File audio) {
    this.recordTitle = recordTitle;
    this.duration = duration;
    this.audio = audio;
  }

  String getRecordTitle() {
    return this.recordTitle;
  }

  Duration getDuration() {
    return this.duration;
  }

  String getAudio() {
    return this.audio.path;
  }
}

class RecordedStory {
  late Story story;
  late List<Record> records;

  RecordedStory(Story story, List<Record> records) {
    this.story = story;
    this.records = records;
  }
}
