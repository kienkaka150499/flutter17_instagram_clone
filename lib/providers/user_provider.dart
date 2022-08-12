import 'package:flutter/material.dart';
import 'package:flutter17_instagram_clone/firebases/auth_method.dart';
import 'package:flutter17_instagram_clone/models/user_models.dart';

class UserProvider extends ChangeNotifier {
  UserModel? user;
  final AuthMethod _authMethod = AuthMethod();

  UserModel get getUser => user!;

  Future refreshUser() async {
    UserModel _user = await _authMethod.getUserDetails();
    user = _user;
    notifyListeners();
  }
}
