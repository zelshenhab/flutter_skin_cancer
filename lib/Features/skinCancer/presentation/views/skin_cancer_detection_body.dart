import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;

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

    if (pickedFile != null) {
      File? croppedFile = await _cropImage(File(pickedFile.path));

      if (croppedFile != null) {
        setState(() {
          _image = croppedFile;
          _showResponseBox = true;
          _responseText = "Image selected! Processing...";
        });

        // Send image to Flask API
        await _sendImageToServer(croppedFile);
      }
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    // Crop the image using the ImageCropper package
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    // If image cropping is successful
    if (croppedFile != null) {
      final img.Image image =
          img.decodeImage(File(croppedFile.path).readAsBytesSync())!;

      // Resize the image to 224x224 pixels
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // Save the resized image as a PNG file
      final resizedImageFile = File('${croppedFile.path}_resized.png')
        ..writeAsBytesSync(img.encodePng(resizedImage));

      // Return the resized image file
      return resizedImageFile;
    }
    // Return null if cropping was not successful
    return null;
  }

  Future<void> _sendImageToServer(File imageFile) async {
    var uri = Uri.parse(
        "http://10.0.2.2:5000/predict"); // Use this for Android Emulator
    var request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);

        // Extract classification and confidence
        String classification = jsonResponse['classification'] ?? "Unknown";
        double confidence = jsonResponse['confidence'] ?? 0.0; // Default to 0.0

        setState(() {
          _responseText = classification == "Malignant"
              ? "⚠️ Malignant - Please consult a doctor immediately!"
              : "✅ Benign - No risk detected.";

          _responseText +=
              "\nConfidence: ${(confidence * 100).toStringAsFixed(2)}%"; // Display confidence percentage
        });
      } else {
        setState(() {
          _responseText = "❌ Error: ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        _responseText =
            "❌ Failed to connect to the server. Make sure it is running.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image == null
              ? const Text(
                  'No image selected.',
                  style: TextStyle(fontSize: 24),
                )
              : Image.file(_image!),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Wrap(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Gallery'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.gallery);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Camera'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.camera);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: const Text(
                'Select Image',
                style: TextStyle(
                  color: Color.fromARGB(255, 134, 50, 219),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Visibility(
            visible: _showResponseBox,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _responseText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
