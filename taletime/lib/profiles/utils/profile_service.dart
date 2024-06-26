import "package:cloud_firestore/cloud_firestore.dart";

import "../models/profile_model.dart";

class ProfileService {
  /// Update the profile with the given [id] with the given [image], [name] and [title].
  static void updateProfile(DocumentReference<Profile> profile, String image,
      String name, String title) {
    profile.update({"image": image, "name": name, "title": title});
  }

  static void deleteProfile(DocumentReference<Profile> profile) {
    profile.delete();
  }

  static void addProfile(CollectionReference<Profile> profiles, String image,
      String name, String title, String language, bool isDarkTheme) {
    profiles.add(Profile(
        image: image,
        name: name,
        title: ProfileType.fromString(title)!,
        id: "",
        language: language,
        theme: isDarkTheme));
  }
}
