import "package:cloud_firestore/cloud_firestore.dart";
import "package:taletime/common/models/added_story.dart";

class Playlist {
  Playlist(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      required this.stories});

  final String? id;
  String? title;
  String? description;
  final String? image;
  List<AddedStory>? stories;

  factory Playlist.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    List<AddedStory> storyConverted = [];

    for (var storyLoaded in snapshot.data()?["stories"] ?? {}) {
      storyConverted
          .add(AddedStory.fromMap(storyLoaded, storyLoaded["id"] ?? ""));
    }

    return Playlist(
      id: snapshot.id,
      title: snapshot.data()?["title"],
      description: snapshot.data()?["description"],
      image: snapshot.data()?["image"],
      stories: storyConverted,
    );
  }

  Map<String, Object?> toFirebase() {
    var mappedStories = stories?.map((e) => e.toFirebase());
    return {
      "title": title,
      "description": description,
      "image": image,
      "stories": mappedStories,
    };
  }
}
