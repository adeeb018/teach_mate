import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:school_management/bloc/register/register_bloc.dart';
import 'package:school_management/pages/homepage/homepage.dart';
import 'package:school_management/pages/registerPage/register_user.dart';

import '../../bloc/home/homepage_bloc.dart';
import '../../pages/loginPage/login_user.dart';

Widget loginUserPageRoute() {
  return const LoginScreen();
}

Widget registerUserPageRoute() {
  return BlocProvider<RegisterBloc>(
    create: (context) => RegisterBloc(),
    child:  const RegisterUser(),
  );
}

Widget homePageRoute() {
  return BlocProvider<HomepageBloc>(
    create: (context) => HomepageBloc(),
    child: HomePage(),
  );
}

class RouterPath {
  /// The route configuration.
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return loginUserPageRoute();
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/register',
            builder: (BuildContext context, GoRouterState state) {
              return registerUserPageRoute();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/homepage',
        builder: (BuildContext context, GoRouterState state) {
          return homePageRoute();
        }
      ),
    ],
  );

}