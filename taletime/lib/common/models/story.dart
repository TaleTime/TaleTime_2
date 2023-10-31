import "package:cloud_firestore/cloud_firestore.dart";

class Story {
  const Story({
    required this.id,
    this.title,
    this.author,
    this.imageUrl,
    this.audioUrl,
    this.rating,
  });

  final String id;

  final String? title;
  final String? author;

  final String? imageUrl;
  final String? audioUrl;

  final String? rating;

  factory Story.fromDocumentSnapshot(DocumentSnapshot<Object?> snapshot) {
    return Story(
      id: snapshot.id,
      title: snapshot.get("title"),
      author: snapshot.get("author"),
      imageUrl: snapshot.get("image"),
      audioUrl: snapshot.get("audio"),
      rating: snapshot.get("rating"),
    );
  }

  Map<String, Object?> toFirebase() {
    return {
      "title": title,
      "author": author,
      "image": imageUrl,
      "audio": audioUrl,
      "rating": rating,
    };
  }
}
