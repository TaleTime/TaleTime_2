import "package:cloud_firestore/cloud_firestore.dart";

enum ProfileType {
  listener(name: "Listener"),
  storyteller(name: "Story-teller");

  const ProfileType({required this.name});

  final String name;

  static ProfileType? fromString(String? name) {
    if (name == null) return null;
    return ProfileType.values
        .firstWhere((e) => e.name == name, orElse: () => ProfileType.listener);
  }

  @override
  String toString() => name;
}

class Profile {
  final String id;
  final String image;
  final String name;
  final ProfileType title;
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
        title: ProfileType.fromString(json["title"])!,
        language: json["language"],
        theme: json["theme"],
      );

  factory Profile.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Profile(
      id: snapshot.id,
      image: snapshot.data()?["image"],
      name: snapshot.data()?["name"],
      title: ProfileType.fromString(snapshot.data()?["title"])!,
      language: snapshot.data()?["language"],
      theme: snapshot.data()?["theme"],
    );
  }

  Map<String, Object?> toFirebase() {
    return {
      "image": image,
      "name": name,
      "title": title.name,
      "language": language,
      "theme": theme,
    };
  }
}
