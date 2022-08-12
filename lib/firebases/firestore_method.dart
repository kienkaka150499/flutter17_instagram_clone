import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter17_instagram_clone/firebases/storage_method.dart';
import 'package:flutter17_instagram_clone/models/post_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String caption, Uint8List file, String uid,
      String username, String profileImage) async {
    String result = '';
    try {
      String photoUrl =
          await StorageMethod().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      PostModel post = PostModel(
        uid: uid,
        username: username,
        caption: caption,
        postId: postId,
        photoUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
        datePublished: DateTime.now(),
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      result = 'success';
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String result = '';
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      result = 'success';
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> postComment(
    String postId,
    String comment,
    String uid,
    String name,
    String profileImage,
  ) async {
    String result = '';
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profileImage': profileImage,
          'comment': comment,
          'name': name,
          'uid': uid,
          'postId': postId,
          'datePublished': DateTime.now(),
        });
        result = 'success';
      } else {
        result = 'Please enter comment';
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> deletePost(String postId) async {
    String result = '';
    try {
      await _firestore.collection('posts').doc(postId).delete();
      result = 'success';
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      List following = (snapshot.data()! as dynamic)['following'];
      
      if(following.contains(followId)){
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      }else{
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      e.toString();
    }
  }
}
