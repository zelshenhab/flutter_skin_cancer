import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  // اللغة الافتراضية هي الإنجليزية
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  // تغيير اللغة وتحديث الـ UI
  void setLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // قاموس الترجمات (English - Arabic - Russian)
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'signUp': 'Sign Up',
      'createAccount': 'Create your account',
      'username': 'Username',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'signInWithGoogle': 'Sign In with Google',
      'alreadyHaveAccount': 'Already have an account? ',
      'login': 'Login',
      'or': 'Or',
      'passwordsDoNotMatch': 'Passwords do not match.',
      'weakPassword': 'The password provided is too weak.',
      'emailExists': 'The account already exists for that email.',
      'invalidEmail': 'The email address is badly formatted.',
      'unexpectedError': 'An unexpected error occurred.',
      'welcomeBack': 'Welcome Back',
      'enterCredential': 'Enter your credential to login',
      'forgotPassword': 'Forgot password?',
      'dontHaveAccount': "Don't have an account? ",
      'forgotPasswordTitle': 'Forgot Password?',
      'forgotPasswordInstruction': 'Enter your email to reset your password',
      'pleaseEnterEmail': 'Please enter your email',
      'resetLinkSent': 'Reset link sent to your email',
      'emailNotFound': 'This email was not found',
      'resetPassword': 'Reset Password',
      'rememberPassword': 'Remember your password? ',
    },
    'ar': {
      'signUp': 'تسجيل',
      'createAccount': 'أنشئ حسابك',
      'username': 'اسم المستخدم',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirmPassword': 'تأكيد كلمة المرور',
      'signInWithGoogle': 'تسجيل الدخول باستخدام جوجل',
      'alreadyHaveAccount': 'هل لديك حساب؟ ',
      'login': 'دخول',
      'or': 'أو',
      'passwordsDoNotMatch': 'كلمات المرور غير متطابقة.',
      'weakPassword': 'كلمة المرور ضعيفة جدًا.',
      'emailExists': 'الحساب موجود بالفعل لهذا البريد.',
      'invalidEmail': 'تنسيق البريد الإلكتروني خاطئ.',
      'unexpectedError': 'حدث خطأ غير متوقع.',
      'welcomeBack': 'مرحباً بعودتك',
      'enterCredential': 'أدخل بياناتك لتسجيل الدخول',
      'forgotPassword': 'هل نسيت كلمة المرور؟',
      'dontHaveAccount': "ليس لديك حساب؟ ",
      'forgotPasswordTitle': 'هل نسيت كلمة المرور؟',
      'forgotPasswordInstruction':
          'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور',
      'pleaseEnterEmail': 'من فضلك أدخل بريدك الإلكتروني',
      'resetLinkSent': 'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني',
      'emailNotFound': 'هذا البريد الإلكتروني غير موجود',
      'resetPassword': 'إعادة تعيين كلمة المرور',
      'rememberPassword': 'تتذكر كلمة المرور؟ ',
    },
    'ru': {
      'signUp': 'Регистрация',
      'createAccount': 'Создайте свою учетную запись',
      'username': 'Имя пользователя',
      'email': 'Электронная почта',
      'password': 'Пароль',
      'confirmPassword': 'Подтвердите пароль',
      'signInWithGoogle': 'Войти через Google',
      'alreadyHaveAccount': 'Уже есть аккаунт? ',
      'login': 'Вход',
      'or': 'Или',
      'passwordsDoNotMatch': 'Пароли не совпадают.',
      'weakPassword': 'Пароль слишком слабый.',
      'emailExists': 'Этот адрес уже зарегистрирован.',
      'invalidEmail': 'Неверный формат электронной почты.',
      'unexpectedError': 'Произошла неожиданная ошибка.',
      'welcomeBack': 'С возвращением',
      'enterCredential': 'Введите свои данные для входа',
      'forgotPassword': 'Забыли пароль?',
      'dontHaveAccount': "Нет учетной записи? ",
      'forgotPasswordTitle': 'Забыли пароль?',
      'forgotPasswordInstruction':
          'Введите свою электронную почту, чтобы сбросить пароль',
      'pleaseEnterEmail': 'Пожалуйста, введите свою электронную почту',
      'resetLinkSent': 'Ссылка для сброса отправлена на вашу почту',
      'emailNotFound': 'Эта почта не найдена',
      'resetPassword': 'Сбросить пароль',
      'rememberPassword': 'Помните свой пароль? ',
    },
  };

  // استرجاع النص حسب اللغة الحالية
  String getLocalizedString(String key) {
    return _translations[_locale.languageCode]?[key] ?? key;
  }
}
