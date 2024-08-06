import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zego_call_test/constants.dart';
import 'package:zego_call_test/screens/home_screen.dart';
import 'package:zego_call_test/screens/loading_page.dart';
import 'package:zego_call_test/screens/login_page.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final navigatorKey = GlobalKey<NavigatorState>();
  ZegoUIKit().initLog().then((value) {
    runApp(MyApp(
      navigatorKey: navigatorKey,
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.navigatorKey,
  });
  final GlobalKey<NavigatorState> navigatorKey;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zego Call Kit',
      routes: routes,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      navigatorKey: navigatorKey,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            }

            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data != null) {
                currentUser.id = snapshot.data!.uid;
                return Stack(
                  children: [
                    const HomePage(),
                    ZegoUIKitPrebuiltCallMiniOverlayPage(
                      contextQuery: () {
                        return navigatorKey.currentState!.context;
                      },
                    ),
                  ],
                );
              }
            }
            return const LoginPage();
          }),
    );
  }
}
