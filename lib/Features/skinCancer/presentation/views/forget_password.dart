import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skin_cancer/core/localization/language_provider.dart';
import 'package:provider/provider.dart'; // Don't forget to import provider

class ForgetPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgetPasswordScreen({super.key});

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
                // Text for forgot password, language dependent
                Text(
                  context.watch<LanguageProvider>().locale.languageCode == 'ar'
                      ? 'هل نسيت كلمة المرور؟'
                      : 'Forgot password?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Text for instruction, language dependent
                Text(
                  context.watch<LanguageProvider>().locale.languageCode == 'ar'
                      ? 'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور'
                      : 'Enter your email to reset your password',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // TextField for email with dynamic hintText
                _buildTextField(
                  emailController,
                  context.watch<LanguageProvider>().locale.languageCode == 'ar'
                      ? 'البريد الإلكتروني'
                      : 'Email',
                  Icons.email,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () async {
                    if (emailController.text == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(Provider.of<LanguageProvider>(context,
                                          listen: false)
                                      .locale
                                      .languageCode ==
                                  'ar'
                              ? 'من فضلك أدخل بريدك الإلكتروني'
                              : 'Please Enter Your Email'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(Provider.of<LanguageProvider>(context,
                                          listen: false)
                                      .locale
                                      .languageCode ==
                                  'ar'
                              ? 'تم إرسال رابط إعادة التعيين إلى البريد الإلكتروني'
                              : 'Reset link sent to email'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(Provider.of<LanguageProvider>(context,
                                          listen: false)
                                      .locale
                                      .languageCode ==
                                  'ar'
                              ? 'البريد الإلكتروني غير موجود'
                              : 'This Email Not Found'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    Provider.of<LanguageProvider>(context, listen: false)
                                .locale
                                .languageCode ==
                            'ar'
                        ? 'إعادة تعيين كلمة المرور'
                        : 'Reset Password',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Provider.of<LanguageProvider>(context, listen: false)
                                  .locale
                                  .languageCode ==
                              'ar'
                          ? 'تتذكر كلمة المرور؟'
                          : 'Remember your password? ',
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Go back to login screen
                      },
                      child: Text(
                        Provider.of<LanguageProvider>(context, listen: false)
                                    .locale
                                    .languageCode ==
                                'ar'
                            ? 'تسجيل الدخول'
                            : 'Login',
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
      TextEditingController controller, String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          hintText: hintText, // Dynamic hintText
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
