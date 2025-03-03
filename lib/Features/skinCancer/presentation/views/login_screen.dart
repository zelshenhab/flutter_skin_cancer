import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/forget_password.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/sign_up_screen.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/skin_cancer_detection_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_skin_cancer/core/localization/language_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false; // << الحالة اللي هنستخدمها للزر

  Future<void> handleLogin() async {
    setState(() => isLoading = true); // اول ما يضغط يبدأ التحميل

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
      if (kDebugMode) {
        print("Firebase Error Code: ${e.code}");
      }
      String errorMessage;
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        errorMessage = 'Error: The email address is incorrect.';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'Error: The password is incorrect.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many failed attempts. Try again later.';
      } else {
        errorMessage = 'An unexpected error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => isLoading = false); // بعد النجاح او الفشل يوقف التحميل
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // عنوان الصفحة مع الترجمة حسب اللغة
                Text(
                  context.watch<LanguageProvider>().locale.languageCode == 'ar'
                      ? 'مرحباً بعودتك'
                      : 'Welcome Back',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  context.watch<LanguageProvider>().locale.languageCode == 'ar'
                      ? 'أدخل بياناتك لتسجيل الدخول'
                      : 'Enter your credential to login',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  emailController,
                  context.watch<LanguageProvider>().locale.languageCode == 'ar'
                      ? 'البريد الإلكتروني'
                      : 'Email',
                  Icons.email,
                ),
                _buildTextField(
                    passwordController,
                    context.watch<LanguageProvider>().locale.languageCode ==
                            'ar'
                        ? 'كلمة المرور'
                        : 'Password',
                    Icons.lock,
                    isPassword: true),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed:
                      isLoading ? null : handleLogin, // زر معطل اثناء اللودينج
                  child: isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          context
                                      .watch<LanguageProvider>()
                                      .locale
                                      .languageCode ==
                                  'ar'
                              ? 'تسجيل الدخول'
                              : 'Login',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetPasswordScreen()),
                    );
                  },
                  child: Text(
                    context.watch<LanguageProvider>().locale.languageCode ==
                            'ar'
                        ? 'هل نسيت كلمة المرور؟'
                        : 'Forgot password?',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.watch<LanguageProvider>().locale.languageCode ==
                              'ar'
                          ? "ليس لديك حساب؟ "
                          : "Don't have an account? ",
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        context.watch<LanguageProvider>().locale.languageCode ==
                                'ar'
                            ? "إنشاء حساب"
                            : "Sign Up",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
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
