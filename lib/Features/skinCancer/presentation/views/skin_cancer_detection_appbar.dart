import 'package:flutter/material.dart';

class SkinCancerDetectionAppbar extends StatelessWidget {
  const SkinCancerDetectionAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      toolbarHeight: 45,
      title: Text(
        'Cancer Detection',
        style: TextStyle(
            fontSize: 24,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
