import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SkinCancerDetectionBody extends StatefulWidget {
  const SkinCancerDetectionBody({super.key});

  @override
  State<SkinCancerDetectionBody> createState() =>
      _SkinCancerDetectionBodyState();
}

class _SkinCancerDetectionBodyState extends State<SkinCancerDetectionBody> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image == null ? Text('No image selected.') : Image.file(_image!),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Select Image'),
          ),
        ],
      ),
    );
  }
}
