import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/constants/constant_strings.dart';

import '../../bloc/login/login_bloc.dart';
import '../../constants/widgets/loading_stack_widget.dart';
import '../../constants/widgets/scaffold_notification.dart';
import '../../constants/widgets/basic_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc(),
        child: BlocConsumer<LoginBloc, LoginState>(
          builder: (BuildContext context, state) {
            if (state is LoginInitial) {
              return LoginUser();
            }
            if (state is LoadingState) {
              // Loading overlay
              return Stack(children: [LoginUser(), const LoadingStackWidget()]);
            } else if (state is LoginSuccess) {
              // Future.microtask(() {
              //   Navigator.pushReplacement(context, homePageRoute());
              // });
              return Stack(children: [LoginUser(), const LoadingStackWidget()]);
            } else if (state is LoginFailed) {
              return LoginUser();
            } else {
              return const Center(
                child: Text(StringConstants.somethingWentWrong),
              );
            }
          },
          listener: (BuildContext context, LoginState state) {
            if (state is LoginFailed) {
              ScaffoldSnackBar.of(context).show(state.error);
            } else if (state is LoginSuccess) {
              context.go('/homepage');
              // Navigator.pushReplacement(context, homePageRoute());
            }
          },
        ),
      ),
    );
  }
}

class LoginUser extends StatelessWidget {
  LoginUser({super.key});

  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BasicTextField(
            title: StringConstants.emailTextTitle,
            hintText: StringConstants.emailAddressHint,
            controller: emailEditingController,
          ),
          BasicTextField(
            title: StringConstants.passwordTextTitle,
            hintText: StringConstants.passwordHint,
            controller: passwordEditingController,
          ),
          ElevatedButton(
              onPressed: () async {
                log('Sign In pressed');
                context.read<LoginBloc>().add(SignInEvent(
                      email: emailEditingController.text,
                      password: passwordEditingController.text,
                    ));
              },
              child: const Text(StringConstants.logInText)),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                log('Sign In with Google pressed');
                context.read<LoginBloc>().add(SignInWithGoogleEvent());
              },
              child: const Text(StringConstants.signInWithGoogle)),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                // go to registration page
                // Navigator.pushReplacement(context, registerUserPageRoute());
                context.push('/register');
              },
              child: const Text(StringConstants.registerText))
        ],
      ),
    );
  }
}
