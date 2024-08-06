// Flutter imports:

// ignore_for_file: use_build_context_synchronously

// Flutter imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zego_call_test/comment.dart';
import 'package:zego_call_test/constants.dart';
import 'package:zego_call_test/database/firebase_methods.dart';
// Package imports:
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// Project imports:

class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CallPageState();
}

class CallPageState extends State<CallPage> {
  void endCall(String callerId, String receiverId) async {
    currentUser.isCalling = false;
    await FirebaseMethods().endCall(callerId, receiverId);
    Navigator.pushNamedAndRemoveUntil(
      currentUser.callContext!,
      PageRouteNames.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <dynamic, dynamic>{}) as Map<dynamic, dynamic>;
    final callID = arguments[PageParam.call_id] ?? '';
    final callerId = arguments[PageParam.callerId] ?? '';
    final receiverId = arguments[PageParam.receiver_id] ?? '';
    final bool isVideo = arguments[PageParam.isVideo] ?? false;
    return WillPopScope(
      onWillPop: () async {
        return await Future.value(false);
      },
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("calls")
              .doc(currentUser.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            /*
            if (snapshot.hasData) {
              if (!snapshot.data!.exists) {
                endCall(callerId, receiverId);
              }
            }
            */
            return SafeArea(
              child: ZegoUIKitPrebuiltCall(
                appID: 0000000,
                /*input your AppID*/
                appSign:
                    "0000000" /*input your AppSign*/,
                userID: currentUser.id,
                userName: currentUser.name,
                callID: callID,
                onDispose: () {},
                config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()

                  /// support minimizing
                  ..topMenuBarConfig =
                      ZegoTopMenuBarConfig(isVisible: true, buttons: [
                    ZegoMenuBarButtonName.minimizingButton,
                    ZegoMenuBarButtonName.showMemberListButton,
                    ZegoMenuBarButtonName.switchCameraButton,
                    ZegoMenuBarButtonName.toggleMicrophoneButton,
                    ZegoMenuBarButtonName.toggleCameraButton,
                  ])
                  ..avatarBuilder = customAvatarBuilder
                  ..onHangUp = () {
                    endCall(callerId, receiverId);
                  }
                  ..turnOnCameraWhenJoining = isVideo
                  ..onOnlySelfInRoom = (context) {
                    if (PrebuiltCallMiniOverlayPageState.idle !=
                        ZegoUIKitPrebuiltCallMiniOverlayMachine().state()) {
                      ZegoUIKitPrebuiltCallMiniOverlayMachine()
                          .changeState(PrebuiltCallMiniOverlayPageState.idle);
                    } else {
                      endCall(callerId, receiverId);
                    }
                  },
              ),
            );
          }),
    );
  }
}
