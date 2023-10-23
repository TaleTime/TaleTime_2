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
    return title;
  }

  String getImagePath() {
    return imagePath;
  }
}

class MyRecord {
  late String audio;

  MyRecord(String audio) {
    this.audio = audio;
  }

  String getAudioPath() {
    return audio;
  }
}

class RecordedStory {
  late Story story;
  late MyRecord recording;

  RecordedStory(Story story, MyRecord recording) {
    this.story = story;
    this.recording = recording;
  }
}

class ChipModel {
  final String id;
  final String name;
  ChipModel({required this.id, required this.name});
}
