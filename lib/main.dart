import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/constants/constant_strings.dart';
import 'package:school_management/pages/homepage/homepage.dart';
import 'package:school_management/pages/loginPage/login_user.dart';
import 'package:school_management/pages/registerPage/register_user.dart';
import 'package:school_management/utils/route/routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          authDomain: "schoolmanagement-5dfac.firebaseapp.com",
          apiKey: FirebaseConstants.apiKey,
          appId: FirebaseConstants.appId,
          messagingSenderId: FirebaseConstants.messagingSenderId,
          projectId: FirebaseConstants.projectId));

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
