// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:zego_call_test/constants.dart';
import 'package:zego_call_test/database/auth_methods.dart';
import 'package:zego_call_test/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHidden = true;
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  void logIn() async {
    if (_mailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      bool response = await AuthMethods()
          .logIn(_mailController.text, _passwordController.text);
      if (response) {
        Navigator.pushNamed(
          context,
          PageRouteNames.home,
        );
      } else {
        Utils().showSnackBar(
            context: context, content: "Giriş yapılırken bir hata oluştu!");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 38.0,
              ),
              Image.asset(
                "assets/video-chat.png",
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Text(
                "ZEGO CALL",
                style: TextStyle(fontFamily: "poppins", fontSize: 20),
              ),
              Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextFormField(
                  controller: _mailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.mail_rounded),
                    hintText: "Gmail Adresi",
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextFormField(
                  obscureText: isHidden,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isHidden = !isHidden;
                        });
                      },
                      icon: Icon(
                          isHidden ? Icons.visibility_off : Icons.visibility),
                    ),
                    hintText: "Password",
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(
                      Colors.lightBlue,
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          25,
                        ),
                      ),
                    )),
                onPressed: () {
                  logIn();
                },
                child: !isLoading
                    ? const Text(
                        "Giriş Yap",
                        style: TextStyle(fontFamily: "poppins"),
                      )
                    : const SizedBox(
                        width: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
              Divider(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    PageRouteNames.register,
                  );
                },
                child: Text("Kayıt Ol"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
