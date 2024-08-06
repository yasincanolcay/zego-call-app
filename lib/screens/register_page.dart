// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zego_call_test/constants.dart';
import 'package:zego_call_test/database/auth_methods.dart';
import 'package:zego_call_test/utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool isHidden = true;
  Uint8List? image;
  bool isLoading = false;

  void singIn() async {
    if (_mailController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      bool response = await AuthMethods().signInUser(
        _mailController.text,
        _passwordController.text,
        _usernameController.text,
        _bioController.text,
        image,
      );
      if (response) {
        Navigator.pushNamed(
          context,
          PageRouteNames.login,
        );
      } else {
        Utils().showSnackBar(
            context: context, content: "Hesap oluşturulurken bir hata oluştu!");
      }
    } else {
      Utils().showSnackBar(context: context, content: "Lütfen gerekli alanları doldurun!");
    }
    setState(() {
      isLoading = false;
    });
  }

  void selectProfilePhoto(ImageSource source) async {
    String selectedImg = await Utils().pickImage(source);
    if (selectedImg.isNotEmpty) {
      cropImage(selectedImg);
    }
  }

  Future<CroppedFile?> cropImage(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Kırp',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Kırp',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      image = await croppedFile.readAsBytes();
      setState(() {});
    }
    return croppedFile;
  }

  @override
  void dispose() {
    _mailController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(
          context,
          PageRouteNames.login,
        );
        return await Future.value(false);
      },
      child: Scaffold(
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
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Text(
                  "ZEGO CALL",
                  style: TextStyle(fontFamily: "poppins", fontSize: 20),
                ),
                Stack(
                  children: [
                    image == null
                        ? const CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                "https://cdn-icons-png.flaticon.com/128/3177/3177440.png"),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: MemoryImage(image!),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          selectProfilePhoto(ImageSource.gallery);
                        },
                        icon: Icon(Icons.add_a_photo_rounded),
                      ),
                    )
                  ],
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
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
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person),
                      hintText: "Username",
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
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
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextFormField(
                    controller: _bioController,
                    minLines: 4,
                    maxLines: 4,
                    maxLength: 150,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.description_rounded),
                      hintText: "Biyografi",
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
                  onPressed: singIn,
                  child: !isLoading
                      ? const Text(
                          "Kayıt Ol",
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
                      PageRouteNames.login,
                    );
                  },
                  child: Text("Giriş Yap"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
