import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File? file;

  Future<void> getimage() async {
    final picker = ImagePicker();
    // Capture a photo.
    final XFile? imagecamera = await picker.pickImage(source: ImageSource.gallery);
    if (imagecamera == null) return;
    setState(() {
      file = File(imagecamera.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("image picker")),
      body: Column(
        children: [
          MaterialButton(
            onPressed: getimage,
            child: const Text("Pick Image"),
          ),
          if (file != null) Image.file(file!),
        ],
      ),
    );
  }
}
