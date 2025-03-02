import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SkinCancerDetectionAppbar extends StatelessWidget {
  const SkinCancerDetectionAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      automaticallyImplyLeading: false,
      toolbarHeight: 45,
      actions: [
        IconButton(
          onPressed: () async {
            GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.disconnect();
            await FirebaseAuth.instance.signOut();
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          icon: Icon(Icons.exit_to_app),
          color: Colors.white,
        )
      ],
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
