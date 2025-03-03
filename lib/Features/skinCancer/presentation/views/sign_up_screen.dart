import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/skin_cancer_detection_view.dart';
import 'package:flutter_skin_cancer/core/localization/language_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  Future signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SkinCancerDetectionView()),
    );
  }

  Future<void> handleSignUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An unexpected error occurred.';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      setState(() => isLoading = false);
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
                // زر تغيير اللغة هنا فوق العنوان
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<LanguageProvider>(
                        builder: (context, languageProvider, child) {
                      return IconButton(
                        icon: Icon(Icons.language),
                        onPressed: () {
                          languageProvider.toggleLanguage();
                        },
                      );
                    }),
                  ],
                ),
                // عنوان التسجيل
                Text(
                  context.watch<LanguageProvider>().locale.languageCode == 'ar'
                      ? 'تسجيل الحساب'
                      : 'Sign Up',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  context.watch<LanguageProvider>().locale.languageCode == 'ar'
                      ? 'أنشئ حسابك'
                      : 'Create your account',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                _buildTextField(
                    usernameController,
                    context.watch<LanguageProvider>().locale.languageCode ==
                            'ar'
                        ? 'اسم المستخدم'
                        : 'Username',
                    Icons.person),
                _buildTextField(
                    emailController,
                    context.watch<LanguageProvider>().locale.languageCode ==
                            'ar'
                        ? 'البريد الإلكتروني'
                        : 'Email',
                    Icons.email),
                _buildTextField(
                    passwordController,
                    context.watch<LanguageProvider>().locale.languageCode ==
                            'ar'
                        ? 'كلمة المرور'
                        : 'Password',
                    Icons.lock,
                    isPassword: true),
                _buildTextField(
                    confirmPasswordController,
                    context.watch<LanguageProvider>().locale.languageCode ==
                            'ar'
                        ? 'تأكيد كلمة المرور'
                        : 'Confirm Password',
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
                  onPressed: isLoading ? null : handleSignUp,
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          context
                                      .watch<LanguageProvider>()
                                      .locale
                                      .languageCode ==
                                  'ar'
                              ? 'تسجيل'
                              : 'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                SizedBox(height: 10),
                Text(context.watch<LanguageProvider>().locale.languageCode ==
                        'ar'
                    ? "أو"
                    : "Or"),
                SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    signInWithGoogle(context);
                  },
                  child: Text(
                      context.watch<LanguageProvider>().locale.languageCode ==
                              'ar'
                          ? 'تسجيل الدخول باستخدام جوجل'
                          : 'Sign In with Google',
                      style: TextStyle(color: Colors.deepPurple, fontSize: 16)),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        context.watch<LanguageProvider>().locale.languageCode ==
                                'ar'
                            ? "هل لديك حساب؟ "
                            : "Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        context.watch<LanguageProvider>().locale.languageCode ==
                                'ar'
                            ? "دخول"
                            : "Login",
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
