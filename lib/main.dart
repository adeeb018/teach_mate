
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/constants/constant_strings.dart';
import 'package:school_management/pages/homepage/homepage.dart';
import 'package:school_management/pages/loginPage/login_user.dart';
import 'package:school_management/pages/registerPage/register_user.dart';
import 'package:school_management/utils/route/routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY']!,
        appId: dotenv.env['FIREBASE_APP_ID']!,
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN']!,
      ));

  // disable browser back button
  setUrlStrategy(null);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: RouterPath.router,
    );
  }
}

