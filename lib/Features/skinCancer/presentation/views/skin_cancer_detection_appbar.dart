import 'package:flutter/material.dart';

class SkinCancerDetectionAppbar extends StatelessWidget {
  const SkinCancerDetectionAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Cancer Detection',
        style: TextStyle(
            fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
