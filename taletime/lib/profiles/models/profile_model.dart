import "package:cloud_firestore/cloud_firestore.dart";

class Profile {
  final String id;
  final String image;
  final String name;
  final String title;
  final String language;
  final bool theme;

  Profile({
    required this.id,
    required this.image,
    required this.name,
    required this.title,
    required this.language,
    required this.theme,
  });

  factory Profile.fromJson(Map<dynamic, dynamic> json) => Profile(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        title: json["title"],
        language: json["language"],
        theme: json["theme"],
      );

  factory Profile.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Profile(
      id: snapshot.id,
      image: snapshot.data()?["image"],
      name: snapshot.data()?["name"],
      title: snapshot.data()?["title"],
      language: snapshot.data()?["language"],
      theme: snapshot.data()?["theme"],
    );
  }

  Map<String, Object?> toFirebase() {
    return {
      "image": image,
      "name": name,
      "title": title,
      "language": language,
      "theme": theme,
    };
  }
}
