import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/sign_up_screen.dart';
import 'package:flutter_skin_cancer/Features/skinCancer/presentation/views/skin_cancer_detection_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_skin_cancer/core/localization/language_provider.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider<LanguageProvider>(
      create: (context) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: languageProvider.locale,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ar', 'AE'),
              Locale('ru', 'RU'), // إضافة اللغة الروسية
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: Directionality(
              // تحديد اتجاه النص بناءً على اللغة
              textDirection: languageProvider.locale.languageCode == 'ar'
                  ? TextDirection.rtl // العربية من اليمين لليسار
                  : languageProvider.locale.languageCode == 'ru'
                      ? TextDirection.ltr // الروسية من اليسار لليمين
                      : TextDirection.ltr, // الإنجليزية من اليسار لليمين
              child: SignUpScreen(),
            ),
            routes: {
              'skinCancerDetectionView': (context) => SkinCancerDetectionView(),
            },
          );
        },
      ),
    );
  }
}



//  home: FirebaseAuth.instance.currentUser == null
//           ? SignUpScreen()
//           : SkinCancerDetectionView(),


//  child: FirebaseAuth.instance.currentUser == null
//                   ? SignUpScreen() // إذا لم يكن المستخدم مسجلاً الدخول
//                   : SkinCancerDetectionView(), // إذا كان المستخدم مسجلاً الدخول