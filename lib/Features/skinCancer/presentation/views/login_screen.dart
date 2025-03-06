import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/forget_password.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/sign_up_screen.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/skin_cancer_detection_view.dart';
import 'package:flutter_skin_cancer/core/localization/language_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> handleLogin() async {
    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SkinCancerDetectionView()),
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("Firebase Error Code: ${e.code}");

      final lang = context.read<LanguageProvider>();
      String errorMessage;

      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        errorMessage = lang.getLocalizedString('invalidEmail');
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = lang.getLocalizedString('passwordsDoNotMatch');
      } else if (e.code == 'too-many-requests') {
        errorMessage = lang.getLocalizedString('unexpectedError');
      } else {
        errorMessage = lang.getLocalizedString('unexpectedError');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lang.getLocalizedString('welcomeBack'),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  lang.getLocalizedString('enterCredential'),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  emailController,
                  lang.getLocalizedString('email'),
                  Icons.email,
                ),
                _buildTextField(
                  passwordController,
                  lang.getLocalizedString('password'),
                  Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: isLoading ? null : handleLogin,
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          lang.getLocalizedString('login'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetPasswordScreen()),
                    );
                  },
                  child: Text(
                    lang.getLocalizedString('forgotPassword'),
                    style: const TextStyle(color: Colors.deepPurple),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(lang.getLocalizedString('dontHaveAccount')),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        lang.getLocalizedString('signUp'),
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          hintText: hintText,
          filled: true,
          fillColor: Colors.deepPurple.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
