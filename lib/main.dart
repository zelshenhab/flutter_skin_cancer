import 'package:flutter/material.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/skin_cancer_detection_view.dart';

void main() {
  runApp(const SkinCancer());
}

class SkinCancer extends StatelessWidget {
  const SkinCancer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SkinCancerDetectionView(),
    );
  }
}
