import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_call_test/database/storage_methods.dart';
import 'package:zego_call_test/models/user.dart' as usermodel;

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  final _fire = FirebaseFirestore.instance;
  Future<bool> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> signInUser(String email, String password, String username,
      String bio, Uint8List? picture,) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String pictureUrl =
          "https://cdn-icons-png.flaticon.com/128/3177/3177440.png";
      if (picture != null) {
        pictureUrl = await StorageMethods()
            .uploadImageToStorage("Profile", picture);
      }

      usermodel.User user = usermodel.User(
        email: email,
        username: username,
        bio: bio,
        picture: pictureUrl,
        created: DateTime.now(),
        isOnline: true,
        uid: cred.user!.uid,
        bannedUsers: [],
      );

      await _fire.collection("users").doc(cred.user!.uid).set(user.toJson());
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
  Future<void> logOut()async{
    await _auth.signOut();
  }
}
