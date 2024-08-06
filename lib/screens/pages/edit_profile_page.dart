import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zego_call_test/constants.dart';
import 'package:zego_call_test/database/firebase_methods.dart';
import 'package:zego_call_test/models/user.dart';
import 'package:zego_call_test/utils.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? image;
  bool isLoading = false;

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

  void updateProfile() async {
    if (_usernameController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      bool response = await FirebaseMethods().updateProfile(
          image,
          currentUser.user!.picture,
          _usernameController.text,
          _bioController.text);
      if (mounted) {
        if (response) {
          Utils()
              .showSnackBar(context: context, content: "Profil güncellendi!");
        } else {
          Utils().showSnackBar(context: context, content: "Bir hata oluştu!");
        }
      }
      setState(() {
        isLoading = false;
      });
    } else {
      Utils().showSnackBar(
          context: context, content: "Kullanıcı adı boş bırakılamaz!");
    }
  }

  @override
  void initState() {
    _usernameController.text = currentUser.user!.username;
    _bioController.text = currentUser.user!.bio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Profili Düzenle"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 38,
              ),
              Stack(
                children: [
                  image != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: MemoryImage(image!),
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(currentUser.user!.picture),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        selectProfilePhoto(ImageSource.gallery);
                      },
                      icon: const Icon(
                        Icons.add_a_photo_rounded,
                      ),
                    ),
                  )
                ],
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
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person),
                    hintText: "Username...",
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
                  controller: _bioController,
                  minLines: 4,
                  maxLines: 4,
                  maxLength: 150,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.description_rounded),
                    hintText: "Biyografi...",
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
                onPressed: updateProfile,
                child: !isLoading
                    ? const Text(
                        "Kaydet",
                      )
                    : const SizedBox(
                        width: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
