// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_call_test/constants.dart';
import 'package:zego_call_test/database/storage_methods.dart';
import 'package:zego_call_test/models/call.dart';
import 'package:zego_call_test/utils.dart';

class FirebaseMethods {
  final fire = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<bool> makeCall(
      Call call, Call receiver, BuildContext context, bool isOpen) async {
    try {
      var receiverCheck =
          await fire.collection("calls").doc(receiver.receiverId).get();
      //çağrı yap
      if (!receiverCheck.exists || isOpen || receiver.callerId==receiverCheck.data()!["callerId"]) {
        await fire.collection("calls").doc(call.callerId).set(call.toJson());
        await fire
            .collection("calls")
            .doc(receiver.receiverId)
            .set(receiver.toJson());
        Navigator.pushNamed(context, PageRouteNames.call, arguments: {
          PageParam.call_id: call.callId,
          PageParam.callerId: call.callerId,
          PageParam.receiver_id: call.receiverId,
          PageParam.isVideo: call.isVideo,
        });
        currentUser.isCalling = true;
      } else {
        Utils().showSnackBar(context: context, content: "Kullanıcı şuan başka bir aramada!");
      }
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> endCall(String callerId, String receiverId) async {
    try {
      //çağrı kapat
      await fire.collection("calls").doc(callerId).delete();
      await fire.collection("calls").doc(receiverId).delete();
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> updateOnlineStatu(String id, bool statu) async {
    try {
      await fire.collection("users").doc(id).update({
        "isOnline": statu,
      });
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> updateProfile(Uint8List? picture, String currentPicture,
      String username, String bio) async {
    try {
      String pictureUrl = currentPicture;
      if (picture != null) {
        pictureUrl = await StorageMethods()
            .uploadImageToStorage("Profile", picture);
      }
      await fire.collection("users").doc(user!.uid).update({
        "picture": pictureUrl,
        "username": username,
        "bio": bio,
      });
      currentUser.user!.picture = pictureUrl;
      currentUser.user!.username = username;
      currentUser.user!.bio = bio;
      return true;
    } catch (err) {
      return false;
    }
  }
}
