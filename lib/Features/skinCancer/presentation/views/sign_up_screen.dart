import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/skin_cancer_detection_view.dart';
import 'package:flutter_skin_cancer/core/localization/language_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

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

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SkinCancerDetectionView()));
  }

  Future<void> handleSignUp() async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    if (passwordController.text != confirmPasswordController.text) {
      showErrorSnackbar(
          languageProvider.getLocalizedString('passwordsDoNotMatch'));
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          languageProvider.getLocalizedString('unexpectedError');

      if (e.code == 'weak-password') {
        errorMessage = languageProvider.getLocalizedString('weakPassword');
      } else if (e.code == 'email-already-in-use') {
        errorMessage = languageProvider.getLocalizedString('emailExists');
      } else if (e.code == 'invalid-email') {
        errorMessage = languageProvider.getLocalizedString('invalidEmail');
      }

      showErrorSnackbar(errorMessage);
    } catch (e) {
      showErrorSnackbar(languageProvider.getLocalizedString('unexpectedError'));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: DropdownButton<String>(
                        value: languageProvider.locale.languageCode,
                        icon: const Icon(Icons.language,
                            color: Colors.deepPurple),
                        underline: Container(height: 0),
                        onChanged: (String? newLanguage) {
                          if (newLanguage != null) {
                            languageProvider.setLanguage(newLanguage);
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'ar', child: Text('العربية')),
                          DropdownMenuItem(value: 'ru', child: Text('Русский')),
                        ],
                      ),
                    ),
                    Text(
                      languageProvider.getLocalizedString('signUp'),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      languageProvider.getLocalizedString('createAccount'),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: usernameController,
                      hintText: languageProvider.getLocalizedString('username'),
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      controller: emailController,
                      hintText: languageProvider.getLocalizedString('email'),
                      icon: Icons.email,
                    ),
                    _buildTextField(
                      controller: passwordController,
                      hintText: languageProvider.getLocalizedString('password'),
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    _buildTextField(
                      controller: confirmPasswordController,
                      hintText: languageProvider
                          .getLocalizedString('confirmPassword'),
                      icon: Icons.lock,
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
                      onPressed: isLoading ? null : handleSignUp,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              languageProvider.getLocalizedString('signUp'),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text(languageProvider.getLocalizedString('or')),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () => signInWithGoogle(context),
                      child: Text(
                        languageProvider.getLocalizedString('signInWithGoogle'),
                        style: const TextStyle(
                            color: Colors.deepPurple, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(languageProvider
                            .getLocalizedString('alreadyHaveAccount')),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            languageProvider.getLocalizedString('login'),
                            style: const TextStyle(
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
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
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
