
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/constants/constant_strings.dart';
import 'package:school_management/pages/homepage/homepage.dart';
import 'package:school_management/pages/loginPage/login_user.dart';
import 'package:school_management/pages/registerPage/register_user.dart';
import 'package:school_management/utils/route/routes.dart';

import 'bloc/home/appBar/app_bar_bloc.dart';
import 'bloc/home/homepage_bloc.dart';
import 'core/controllers/getx_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/.env');

  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY']!,
        appId: dotenv.env['FIREBASE_APP_ID']!,
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN']!,
      ));

  // disable browser back button
  // setUrlStrategy(null);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  final GetXStoreController storeController = Get.put(GetXStoreController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomepageBloc>(
          create: (context) => HomepageBloc(),
        ),
        BlocProvider<AppBarBloc>(
          create: (context) => AppBarBloc(),
        ),
        // Add more providers as needed
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: RouterPath.router,
      ),
    );
  }
}

