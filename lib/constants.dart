// Flutter imports:
import 'package:flutter/material.dart';
import 'package:zego_call_test/models/user.dart';
import 'package:zego_call_test/screens/call_page.dart';
import 'package:zego_call_test/screens/home_screen.dart';
import 'package:zego_call_test/screens/pages/edit_profile_page.dart';
import 'package:zego_call_test/screens/register_page.dart';

// Package imports:

// Project imports:
import 'screens/login_page.dart';

class PageRouteNames {
  static const String login = '/login';
  static const String home = '/home_page';
  static const String call = '/call';
  static const String register = '/register';
  static const String profile = '/profile';
}

class PageParam {
  static const String call_id = 'call_id';
  static const String callerId = 'caller_id';
  static const String receiver_id = 'receiver_id';
  static const bool isVideo = true;
}

const TextStyle textStyle = TextStyle(
  color: Colors.black,
  fontSize: 13.0,
  decoration: TextDecoration.none,
);

Map<String, WidgetBuilder> routes = {
  PageRouteNames.login: (context) => const LoginPage(),
  PageRouteNames.home: (context) =>  const HomePage(),
  PageRouteNames.call: (context) => const CallPage(),
  PageRouteNames.register: (context) => const RegisterPage(),
  PageRouteNames.profile:(context) => const EditProfilePage(),
};

class UserInfo {
  String id = '';
  String name = '';
  String picture = '';
  bool isCalling = false;
  int tabIndex = 0;
  BuildContext? callContext = null;
  User? user = null;

  UserInfo({
    required this.id,
    required this.name,
    required this.picture,
    required this.isCalling,
    required this.tabIndex,
    required this.callContext,
    required this.user,
  });

  bool get isEmpty => id.isEmpty;

  UserInfo.empty();
}

UserInfo currentUser = UserInfo.empty();