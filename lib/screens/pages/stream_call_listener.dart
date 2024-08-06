import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zego_call_test/constants.dart';
import 'package:zego_call_test/database/firebase_methods.dart';
import 'package:zego_call_test/models/call.dart';
import 'package:zego_call_test/utils.dart';

class StreamCallListener extends StatelessWidget {
  const StreamCallListener({
    super.key,
    required this.scaffold,
  });
  final Widget scaffold;

  void endCall(Call call,BuildContext context) async {
    bool response =
        await FirebaseMethods().endCall(call.callId, call.receiverId);
    if (!response) {
      Utils()
          .showSnackBar(context: context, content: "Çağrı sonlandırılamadı!");
    }
  }

  void openCall(Call call,BuildContext context) async {
    currentUser.isCalling = true;
    bool response = await FirebaseMethods().makeCall(call, call, context, true);
    if (!response) {
      Utils().showSnackBar(context: context, content: "Çağrı yanıtlanamadı!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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

        if (snapshot.data!.exists) {
          Utils utils = Utils();
          if (!snapshot.data!.data()!["hasDialled"]) {
            //sesi çal
            utils.playSound(UrlSource(
                "https://cdn.pixabay.com/audio/2023/05/29/audio_2494e8a52b.mp3"));
          } else {
            //sesi durdur
            utils.stopSound();
          }
          return Stack(
            children: [
              scaffold,
              !snapshot.data!.data()!["hasDialled"]
                  ? Positioned(
                      top: 40,
                      left: 8.0,
                      right: 8.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(
                          25,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                25,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5.0,
                                  spreadRadius: 2.0,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ]),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.data()!["callerPic"]),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.data()!["callerName"],
                                        style: const TextStyle(
                                          fontFamily: "poppins",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data!.data()!["isVideo"]
                                            ? "Gelen Görüntülü Arama.."
                                            : "Gelen Sesli Arama...",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll(Colors.red),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Call call = Call.fromSnap(snapshot.data!);
                                      endCall(call, context);
                                    },
                                    icon: const Icon(
                                      Icons.call_end_rounded,
                                      color: Colors.white,
                                    ),
                                    label: const Text("Reddet"),
                                  ),
                                  ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor: const MaterialStatePropertyAll(
                                          Colors.green),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Call call = Call.fromSnap(snapshot.data!);
                                      openCall(call,context);
                                    },
                                    icon: Icon(
                                      snapshot.data!.data()!["isVideo"]
                                          ? Icons.video_call_rounded
                                          : Icons.call,
                                      color: Colors.white,
                                    ),
                                    label: const Text("Cevapla"),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        }
        return scaffold;
      },
    );
  }
}
