import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = Locale('en'); // لغة افتراضية هي الإنجليزية

  // النصوص لكل لغة
  final Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'signUp': 'Sign Up',
      'createAccount': 'Create your account',
      'or': 'Or',
      'signInWithGoogle': 'Sign In with Google',
      'alreadyHaveAccount': 'Already have an account? ',
      'login': 'Login',
    },
    'ar': {
      'signUp': 'إنشاء حساب',
      'createAccount': 'أنشئ حسابك',
      'or': 'أو',
      'signInWithGoogle': 'تسجيل الدخول باستخدام جوجل',
      'alreadyHaveAccount': 'هل لديك حساب؟ ',
      'login': 'تسجيل الدخول',
    }
  };

  Locale get locale => _locale;

  // جلب النصوص بناءً على اللغة
  String getLocalizedString(String key) {
    return _localizedStrings[_locale.languageCode]?[key] ?? key;
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'en') {
      _locale = Locale('ar'); // التبديل إلى العربية
    } else {
      _locale = Locale('en'); // التبديل إلى الإنجليزية
    }
    notifyListeners();
  }
}
