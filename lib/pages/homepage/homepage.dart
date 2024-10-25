import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/bloc/home/homepage_bloc.dart';
import 'package:school_management/constants/constant_strings.dart';
import 'package:school_management/constants/widgets/loading_stack_widget.dart';
import 'package:school_management/constants/widgets/scaffold_notification.dart';
import 'package:school_management/models/user_model.dart';

import 'homepage_appbar.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomepageBloc, HomepageState>(
        builder: (context, state) {
          if (state is HomepageInitial) {
            return HomePageWidget();
          } else if (state is LoadingState) {
            return Stack(children: [
              HomePageWidget(),
              LoadingStackWidget()
            ]);
          } else if (state is SignOutSuccess) {
            return Stack(children: [
              HomePageWidget(),
              LoadingStackWidget()
            ]);
          } else if (state is SignOutError) {
            return HomePageWidget();
          } else {
            return const Center(
              child: Text(StringConstants.somethingWentWrong),
            );
          }
        },
        listener: (context, state) {
          if (state is SignOutError) {
            ScaffoldSnackBar.of(context).show(state.error);
          } else if (state is SignOutSuccess) {
            context.go('/');
          }
        },
      ),
    );
  }
}

class HomePageWidget extends StatelessWidget {

  HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomePageAppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // context.read<HomepageBloc>().add(AddStudentEvent());
          },
          child: const Text(
            StringConstants.addNewStudent,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}