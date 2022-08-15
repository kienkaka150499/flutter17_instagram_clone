import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String username;
  String uid;
  String email;
  String photoUrl;
  List followers;
  List following;
  String dateOfBirth;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.followers,
    required this.following,
    required this.photoUrl,
    this.dateOfBirth = '01/01/1900',
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "followers": followers,
        "following": following,
        "dateOfBirth": dateOfBirth,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      dateOfBirth: snapshot["dateOfBirth"],
    );
  }
}
