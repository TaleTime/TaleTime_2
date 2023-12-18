import "package:cloud_firestore/cloud_firestore.dart";

class TaleTimeUser {
  final String id;
  final String username;

  final String email;

  const TaleTimeUser({
    required this.id,
    required this.email,
    required this.username
  });

  factory TaleTimeUser.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return TaleTimeUser(
      id: snapshot.id,
      email: snapshot.data()?["email"],
      username: snapshot.data()?["username"],
    );
  }

  Map<String, Object?> toFirebase() {
    return {
      id: id,
      email: email,
      username: username,
    };
  }
}
