import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'image_picker_utils.dart'; // Import the utility class

class SkinCancerDetectionBody extends StatefulWidget {
  const SkinCancerDetectionBody({super.key});

  @override
  State<SkinCancerDetectionBody> createState() =>
      _SkinCancerDetectionBodyState();
}

class _SkinCancerDetectionBodyState extends State<SkinCancerDetectionBody> {
  File? _image;
  bool _showResponseBox = false;
  String _responseText = "Your response will appear here.";

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _showResponseBox = true;
        _responseText = "Image selected! Processing..."; // Simulate a response
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });

    // Simulate processing delay
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _responseText =
          "Analysis complete: No issues detected."; // Simulate a final response
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image == null
              ? Text(
                  'No image selected.',
                  style: TextStyle(fontSize: 24),
                )
              : Image.file(_image!),
          SizedBox(height: 30),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(bottom: _showResponseBox ? 50 : 0),
            child: GestureDetector(
              onTap: () {
                // Use the utility class to show the dialog
                ImagePickerUtils.showImageSourceDialog(
                  context: context,
                  onImageSourceSelected: (source) {
                    _pickImage(
                        source); // Call _pickImage with the selected source
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1), // White background
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Select Image',
                  style: TextStyle(
                    color:
                        const Color.fromARGB(255, 134, 50, 219), // Purple text
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _showResponseBox,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _responseText,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
