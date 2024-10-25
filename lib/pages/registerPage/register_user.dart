import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/bloc/register/register_bloc.dart';
import 'package:school_management/constants/constant_strings.dart';
import 'package:school_management/constants/widgets/loading_stack_widget.dart';
import 'package:school_management/constants/widgets/basic_text_field.dart';

import '../../constants/widgets/scaffold_notification.dart';
import '../../utils/route/routes.dart';

class RegisterUser extends StatelessWidget {
  const RegisterUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigator.pushReplacement(context, loginUserPageRoute());
            context.go('/');
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: BlocProvider(
        create: (context) => RegisterBloc(),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          builder: (context, state) {
            if (state is RegisterInitial) {
              return RegisterWidget();
            }
            if (state is LoadingState) {
              return Stack(
                  children: [RegisterWidget(), const LoadingStackWidget()]);
            } else if (state is RegisterSuccess || state is RegisterFailed) {
              return RegisterWidget();
            } else {
              return const Center(
                child: Text(StringConstants.somethingWentWrong),
              );
            }
          },
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldSnackBar.of(context).show(state.message);
            } else if (state is RegisterFailed) {
              ScaffoldSnackBar.of(context).show(state.error);
            }
          },
        ),
      ),
    );
  }
}

class RegisterWidget extends StatelessWidget {
  RegisterWidget({super.key});

  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BasicTextField(
              title: StringConstants.nameTextTitle,
              hintText: StringConstants.nameTextHint,
              controller: nameEditingController),
          BasicTextField(
              title: StringConstants.emailTextTitle,
              hintText: StringConstants.emailAddressHint,
              controller: emailEditingController),
          BasicTextField(
              title: StringConstants.passwordTextTitle,
              hintText: StringConstants.passwordHint,
              controller: passwordEditingController),
          ElevatedButton(
              onPressed: () async {
                // validate email
                log('SignUp pressed');
                context.read<RegisterBloc>().add(RegisterUserEvent(
                    name: nameEditingController.text,
                    email: emailEditingController.text,
                    password: passwordEditingController.text));
              },
              child: const Text(StringConstants.signUpText)),
        ],
      ),
    );
  }
}
