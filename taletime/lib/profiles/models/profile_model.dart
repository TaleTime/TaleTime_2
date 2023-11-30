import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";

class Profile {
  String id;
  String image;
  String name;
  String title;
  String language;
  bool theme;

  Profile(
      this.id, this.image, this.name, this.title, this.language, this.theme);

  factory Profile.fromJson(Map<dynamic, dynamic> json) => Profile(
        json["id"],
        json["image"],
        json["name"],
        json["title"],
        json["language"],
        json["theme"],
      );

  factory Profile.fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Object?> snapshot) {
    return Profile(
      snapshot.id,
      snapshot.get("image"),
      snapshot.get("name"),
      snapshot.get("title"),
      snapshot.get("language"),
      snapshot.get("theme"),
    );
  }
}
