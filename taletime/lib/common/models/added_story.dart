import "package:cloud_firestore/cloud_firestore.dart";
import "package:taletime/common/models/story.dart";

class AddedStory extends Story {
  const AddedStory({
    required super.id,
    super.title,
    super.author,
    super.imageUrl,
    super.audioUrl,
    super.rating,
    this.liked = false,
    this.timeLastListened,
  });

  final bool liked;
  final int? timeLastListened;

  factory AddedStory.fromStory(
      Story story, {
        required bool liked,
        required int timeLastListened,
      }) {
    return AddedStory(
      id: story.id,
      title: story.title,
      author: story.author,
      imageUrl: story.imageUrl,
      audioUrl: story.audioUrl,
      rating: story.rating,
      liked: liked,
      timeLastListened: timeLastListened,
    );
  }

  factory AddedStory.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AddedStory(
      id: snapshot.id,
      title: snapshot.data()?["title"],
      author: snapshot.data()?["author"],
      imageUrl: snapshot.data()?["image"],
      audioUrl: snapshot.data()?["audio"],
      rating: snapshot.data()?["rating"],
      liked: snapshot.data()?["isLiked"] ?? false,
      timeLastListened: snapshot.data()?["timeLastListened"],
    );
  }

  @override
  Map<String, Object?> toFirebase() {
    return {
      "title": title,
      "author": author,
      "image": imageUrl,
      "audio": audioUrl,
      "rating": rating,
      "liked": liked,
      "timeLastListened": timeLastListened,
    };
  }
}
