import 'dart:io';

import 'package:taletime/storyteller/screens/create_story.dart';

class Story {
  /// Instanzvariablen
  late String title;
  late List<String> tags;
  late String imagePath;

  Story(String title, List<String> tags, String imagePath) {
    this.title = title;
    this.tags = tags;
    this.imagePath = imagePath;
  }

  String getTitle() {
    return this.title;
  }

  String getImagePath() {
    return this.imagePath;
  }
}

class Record {
  late String audio;

  Record(String audio) {
    this.audio = audio;
  }

  String getAudioPath() {
    return this.audio;
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

class ChipModel {
  final String id;
  final String name;
  ChipModel({required this.id, required this.name});
}
