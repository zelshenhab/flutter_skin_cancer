import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/sign_up_screen.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/skin_cancer_detection_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SkinCancer());
}

class SkinCancer extends StatefulWidget {
  const SkinCancer({super.key});

  @override
  State<SkinCancer> createState() => _SkinCancerState();
}

class _SkinCancerState extends State<SkinCancer> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (kDebugMode) {
          print('User is currently signed out!');
        }
      } else {
        if (kDebugMode) {
          print('User is signed in!');
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
      routes: {
        'skinCancerDetectionView': (context) => SkinCancerDetectionView(),
      },
    );
  }
}



//  home: FirebaseAuth.instance.currentUser == null
//           ? SignUpScreen()
//           : SkinCancerDetectionView(),