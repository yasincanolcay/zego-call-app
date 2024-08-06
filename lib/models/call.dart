import 'package:cloud_firestore/cloud_firestore.dart';

class Call {
  final String callId;
  final String callerId;
  final String receiverId;
  final String callerName;
  final String receiverName;
  final String callerPic;
  final String receiverPic;
  final bool hasDialled;
  final bool isVideo;

  const Call({
    required this.callId,
    required this.callerId,
    required this.receiverId,
    required this.callerName,
    required this.receiverName,
    required this.callerPic,
    required this.receiverPic,
    required this.hasDialled,
    required this.isVideo,
  });

  Map<String, dynamic> toJson() => {
        "callId": callId,
        "callerId": callerId,
        "receiverId": receiverId,
        "callerName": callerName,
        "receiverName": receiverName,
        "callerPic": callerPic,
        "receiverPic": receiverPic,
        "hasDialled":hasDialled,
        "isVideo":isVideo,
      };

  static Call fromSnap(DocumentSnapshot snap)  {
    final snapshot = (snap.data() as Map<String, dynamic>);
    return Call(
      callId: snapshot["callId"],
      callerId: snapshot["callerId"],
      receiverId: snapshot["receiverId"],
      callerName: snapshot["callerName"],
      receiverName: snapshot["receiverName"],
      callerPic: snapshot["callerPic"],
      receiverPic: snapshot["receiverPic"],
      hasDialled: snapshot["hasDialled"],
      isVideo: snapshot["isVideo"],
    );
  }
}
