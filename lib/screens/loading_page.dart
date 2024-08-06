import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: const Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
