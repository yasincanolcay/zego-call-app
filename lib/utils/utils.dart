import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class Utils {
  AudioPlayer player = AudioPlayer();

  Future<void> playSound(Source source) async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(source);
  }

  Future<void> stopSound() async {
    await player.stop();
  }

  void showSnackBar({required BuildContext context, required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  Future<String> pickImage(ImageSource source) async {
    XFile? pick = await ImagePicker().pickImage(source: source);
    if (pick != null) {
      return pick.path;
    } else {
      return "";
    }
  }
}
