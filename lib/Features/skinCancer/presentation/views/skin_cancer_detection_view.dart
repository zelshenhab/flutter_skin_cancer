import 'package:flutter/material.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/skin_cancer_detection_appbar.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/skin_cancer_detection_body.dart';

class SkinCancerDetectionView extends StatelessWidget {
  const SkinCancerDetectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: SkinCancerDetectionAppbar()),
      body: SkinCancerDetectionBody(),
    );
  }
}
