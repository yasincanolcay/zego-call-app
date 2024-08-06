import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zego_call_test/utils/constants.dart';
import 'package:zego_call_test/models/user.dart';
import 'package:zego_call_test/widgets/user_call_card.dart';

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
