import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../utils/firebase_functions.dart';

class MyProvider extends ChangeNotifier {
  UserModel? userModel;
  User? firebaseUser;
  String? profileImagePath;

  MyProvider() {
    firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      initUser();
    }
  }

  void setProfileImage(String path) {
    profileImagePath = path;
    notifyListeners();
  }

  initUser() async {
    firebaseUser = FirebaseAuth.instance.currentUser;
    userModel = await FirebaseFunctions.readUser(firebaseUser!.uid);
    notifyListeners();
  }
}
