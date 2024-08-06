import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zego_call_test/models/user.dart';

class OfflineUsersPage extends StatefulWidget {
  const OfflineUsersPage({super.key});

  @override
  State<OfflineUsersPage> createState() => _OfflineUsersPageState();
}

class _OfflineUsersPageState extends State<OfflineUsersPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .where("isOnline", isEqualTo: false)
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

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            User user = User.fromSnap(snapshot.data!.docs[index]);
            return UserCard(
              snap: user,
            );
          },
        );
      },
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.snap,
  });
  final User snap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(snap.picture)),
      title: Text(snap.username),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          snap.isOnline
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
          Text(snap.isOnline ? " Online" : "Offline"),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*
       
        çağrı fonksiyonuna buildcontext çağırcagız ve arama ekranına gideceğiz
          
          */
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.video_call_rounded,
              color: Colors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }
}
