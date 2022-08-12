import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String caption;
  final String uid;
  final String username;
  final String photoUrl;
  final String postId;
  final String profileImage;
  final List likes;
  final DateTime datePublished;

  PostModel({
    required this.uid,
    required this.username,
    required this.caption,
    required this.postId,
    required this.photoUrl,
    required this.profileImage,
    required this.likes,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "caption": caption,
        "photoUrl": photoUrl,
        "likes": likes,
        "postId": postId,
        "datePublished": datePublished,
        "profileImage": profileImage,
      };

  PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      uid: snapshot['uid'],
      username: snapshot['username'],
      caption: snapshot['caption'],
      postId: snapshot['postId'],
      photoUrl: snapshot['photoUrl'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
      datePublished: snapshot['datePublished'],
    );
  }
}
