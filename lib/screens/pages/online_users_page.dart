import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_call_test/constants.dart';
import 'package:zego_call_test/database/firebase_methods.dart';
import 'package:zego_call_test/models/call.dart';
import 'package:zego_call_test/models/user.dart';
import 'package:intl/intl.dart';
import 'package:zego_call_test/utils.dart';

class OnlineUsersPage extends StatelessWidget {
  const OnlineUsersPage({
    super.key,
    required this.isOnline,
  });
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .where("isOnline", isEqualTo: isOnline)
            .where("uid", isNotEqualTo: currentUser.id)
            .get(),
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
    
          return snapshot.data!.docs.isNotEmpty
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    User user = User.fromSnap(snapshot.data!.docs[index]);
                    return UserCard(
                      snap: user,
                    );
                  },
                )
              : const Center(
                  child: Text("Hiç Kimseler Yok 😒"),
                );
        },
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  const UserCard({
    super.key,
    required this.snap,
  });
  final User snap;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  void makeCall(bool isVideo) async {
    if (!currentUser.isCalling) {
      String callId = const Uuid().v1();
      Call call = Call(
        callId: callId,
        callerId: currentUser.id,
        receiverId: widget.snap.uid,
        callerName: currentUser.name,
        receiverName: widget.snap.username,
        callerPic: currentUser.picture,
        receiverPic: widget.snap.picture,
        hasDialled: true,
        isVideo: isVideo,
      );

      Call receiver = Call(
        callId: callId,
        callerId: currentUser.id,
        receiverId: widget.snap.uid,
        callerName: currentUser.name,
        receiverName: widget.snap.username,
        callerPic: currentUser.picture,
        receiverPic: widget.snap.picture,
        hasDialled: false,
        isVideo: isVideo,
      );
      bool response = await FirebaseMethods().makeCall(call, receiver, context,false);
      if (!response) {
        if(mounted){
          Utils()
            .showSnackBar(context: context, content: "Şuan arama yapılamıyor");
        }
      }
    } else {
      Utils()
          .showSnackBar(context: context, content: "Devam eden bir çağrı var!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        userAboutBottomSheet(context, widget.snap);
      },
      leading: CircleAvatar(backgroundImage: NetworkImage(widget.snap.picture)),
      title: Text(widget.snap.username),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.snap.isOnline
              ? const Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 16,
                )
              : const Icon(
                  Icons.public_off_outlined,
                  color: Colors.blueGrey,
                  size: 16,
                ),
          Text(widget.snap.isOnline ? " Online" : "Offline"),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              makeCall(false);
            },
            icon: const Icon(
              Icons.call,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          IconButton(
            onPressed: () {
              makeCall(true);
            },
            icon: const Icon(
              Icons.video_call_rounded,
              color: Colors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> userAboutBottomSheet(BuildContext context, User snap) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 10,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(snap.picture),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                snap.username,
                style: const TextStyle(fontFamily: "poppins"),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                DateFormat.yMMMd().add_EEEE().add_Hm().format(
                      widget.snap.created,
                    ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Divider(),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 100),
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(
                    25,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Biyografi",
                      style: TextStyle(
                        fontFamily: "poppins",
                      ),
                    ),
                    Text(snap.bio),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        });
  }
}
