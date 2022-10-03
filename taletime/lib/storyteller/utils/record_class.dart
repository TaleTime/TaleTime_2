import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:taletime/storyteller/screens/create_story.dart';

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
  late Duration duration;
  late File audio;

  Record(File audio, Duration duration) {
    this.duration = duration;
    this.audio = audio;
  }

  Duration getDuration() {
    return this.duration;
  }
}

class RecordedStory {
  late Story story;
  late Record recording;

  RecordedStory(Story story, Record recording) {
    this.story = story;
    this.recording = recording;
  }
}
