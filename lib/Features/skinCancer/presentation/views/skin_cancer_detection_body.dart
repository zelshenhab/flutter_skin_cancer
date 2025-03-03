import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skin_cancer/core/localization/language_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

class SkinCancerDetectionBody extends StatefulWidget {
  const SkinCancerDetectionBody({super.key});

  @override
  State<SkinCancerDetectionBody> createState() =>
      _SkinCancerDetectionBodyState();
}

class _SkinCancerDetectionBodyState extends State<SkinCancerDetectionBody> {
  File? _image;
  bool _showResponseBox = false;
  String _responseText = "";

  late String languageCode;

  @override
  void initState() {
    super.initState();
    // قراءة اللغة مرة واحدة عند بداية الشاشة
    languageCode = Provider.of<LanguageProvider>(context, listen: false)
        .locale
        .languageCode;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      File? croppedFile = await _cropImage(File(pickedFile.path));

      if (croppedFile != null) {
        setState(() {
          _image = croppedFile;
          _showResponseBox = true;
          _responseText = getTranslatedText(
              "تم اختيار الصورة! جاري المعالجة...",
              "Image selected! Processing...");
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
          toolbarTitle: getTranslatedText('قص الصورة', 'Crop Image'),
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: getTranslatedText('قص الصورة', 'Crop Image'),
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
    var uri = Uri.parse("http://10.0.2.2:5000/predict");
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
        double confidence = jsonResponse['confidence'] ?? 0.0;

        setState(() {
          if (classification == "Malignant") {
            _responseText = getTranslatedText(
                "⚠️ خبيث - يرجى استشارة الطبيب فورًا!",
                "⚠️ Malignant - Please consult a doctor immediately!");
          } else {
            _responseText = getTranslatedText(
                "✅ حميد - لا يوجد خطر.", "✅ Benign - No risk detected.");
          }

          _responseText +=
              "\n${getTranslatedText("نسبة الثقة: ", "Confidence: ")}${(confidence * 100).toStringAsFixed(2)}%";
        });
      } else {
        setState(() {
          _responseText = getTranslatedText("❌ خطأ: ${response.reasonPhrase}",
              "❌ Error: ${response.reasonPhrase}");
        });
      }
    } catch (e) {
      setState(() {
        _responseText = getTranslatedText(
            "❌ فشل الاتصال بالخادم. تأكد من أنه يعمل.",
            "❌ Failed to connect to the server. Make sure it is running.");
      });
    }
  }

  String getTranslatedText(String arText, String enText) {
    return languageCode == 'ar' ? arText : enText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image == null
              ? Text(
                  getTranslatedText(
                      'لم يتم اختيار صورة.', 'No image selected.'),
                  style: const TextStyle(fontSize: 24),
                )
              : Image.file(_image!),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => _showImageSourcePicker(),
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
              child: Text(
                getTranslatedText('اختر صورة', 'Select Image'),
                style: const TextStyle(
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

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(getTranslatedText('المعرض', 'Gallery')),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(getTranslatedText('الكاميرا', 'Camera')),
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
  }
}
