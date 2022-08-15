import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter17_instagram_clone/firebases/storage_method.dart';
import 'package:flutter17_instagram_clone/models/user_models.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logout()async{
    await _auth.signOut();
  }

  authStateListen() {
    String res='';
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if(event==null){
        res='User signed out';
      }else {
        res='Signed in';
      }
    });
  }

  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required Uint8List file,
  }) async {
    String result = '';
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        String photoUrl =
            await StorageMethod().uploadImageToStorage('avatar', file, false);
        UserModel userModel = UserModel(
          uid: userCredential.user!.uid,
          username: username,
          email: email,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toJson());
      }
      result = 'success';
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String result = '';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _auth.currentUser!.reload();
        result = 'success';
      } else {
        result = 'Any fields empty';
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot=await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(documentSnapshot);
  }

}
