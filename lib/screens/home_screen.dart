// Flutter imports:
// ignore_for_file: use_build_context_synchronously
// Flutter imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:zego_call_test/constants.dart';
import 'package:zego_call_test/database/auth_methods.dart';
import 'package:zego_call_test/database/firebase_methods.dart';
import 'package:zego_call_test/screens/pages/edit_profile_page.dart';
import 'package:zego_call_test/screens/pages/online_users_page.dart';
import 'package:zego_call_test/screens/pages/stream_call_listener.dart';
import 'package:zego_call_test/utils.dart';

import '../models/user.dart';
// Project imports:

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool isLoading = false;
  void getUserData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    var snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.id)
        .get();
    currentUser.name = snap.data()!["username"];
    currentUser.picture = snap.data()!["picture"];
    currentUser.user = User.fromSnap(snap);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseMethods().updateOnlineStatu(currentUser.id, true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        FirebaseMethods().updateOnlineStatu(currentUser.id, false);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void initState() {
    getUserData();
    WidgetsBinding.instance.addObserver(this);
    currentUser.callContext = context;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return StreamCallListener(
      scaffold: WillPopScope(
        onWillPop: () async {
          return await Future.value(false);
        },
        child: SafeArea(
          child: DefaultTabController(
            initialIndex: currentUser.tabIndex,
            length: 2,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text("ZEGO CALL"),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/video-chat.png",
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: logoutButton(),
                  ),
                ],
                bottom: TabBar(
                    onTap: (value) {
                      setState(() {
                        currentUser.tabIndex = value;
                      });
                    },
                    tabs: [
                      const Tab(
                        icon: Icon(Icons.online_prediction_rounded),
                        child: Text("Online Users"),
                      ),
                      const Tab(
                        icon: Icon(Icons.public_off_outlined),
                        child: Text("Offline Users"),
                      ),
                    ]),
              ),
              body: !isLoading
                  ? const TabBarView(children: [
                      OnlineUsersPage(isOnline: true),
                      OnlineUsersPage(isOnline: false),
                    ])
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget logoutButton() {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () async {
            if (!currentUser.isCalling) {
              await AuthMethods().logOut();
              await FirebaseMethods().updateOnlineStatu(currentUser.id, false);
              Navigator.pushNamed(
                context,
                PageRouteNames.login,
              );
            } else {
              Utils().showSnackBar(
                  context: context,
                  content: "Çağrı devam ederken çıkış yapılamaz!");
            }
          },
          child: const Text("Çıkış Yap"),
        ),
        PopupMenuItem(
          onTap: () {
            if (currentUser.user != null) {
              Navigator.pushNamed(context, PageRouteNames.profile);
            } else {
              Utils().showSnackBar(
                  context: context,
                  content: "Veriler alınırken lütfen bekleyin!");
            }
          },
          child: const Text("Profil"),
        )
      ],
    );
  }
}
