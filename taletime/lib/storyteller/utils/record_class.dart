class RecordStory {
  late String title;
  late List<String> tags;
  late String imagePath;

  RecordStory(this.title, this.tags, this.imagePath);

  String getTitle() {
    return title;
  }

  String getImagePath() {
    return imagePath;
  }
}

class MyRecord {
  late String audio;

  MyRecord(this.audio);

  String getAudioPath() {
    return audio;
  }
}

class RecordedStory {
  late RecordStory story;
  late MyRecord recording;

  RecordedStory(this.story, this.recording);
}

class ChipModel {
  final String id;
  final String name;
  ChipModel({required this.id, required this.name});
}
