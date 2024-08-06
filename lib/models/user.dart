import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  String username;
  String bio;
  String picture;
  final DateTime created;
  final String uid;
  final bool isOnline;
  final List bannedUsers;

  User({
    required this.email,
    required this.username,
    required this.bio,
    required this.picture,
    required this.created,
    required this.isOnline,
    required this.uid,
    required this.bannedUsers,
  });
  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "bio": bio,
        "picture": picture,
        "created": created,
        "isOnline": isOnline,
        "uid": uid,
        "bannedUsers": bannedUsers,
      };
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return User(
      email: snapshot["email"],
      username: snapshot["username"],
      bio: snapshot["bio"],
      picture: snapshot["picture"],
      created: snapshot["created"].toDate(),
      isOnline: snapshot["isOnline"],
      uid: snapshot["uid"],
      bannedUsers: snapshot["bannedUsers"],
    );
  }
}
