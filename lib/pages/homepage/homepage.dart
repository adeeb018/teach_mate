import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/bloc/home/body/body_bloc.dart';
import 'package:school_management/bloc/home/homepage_bloc.dart';
import 'package:school_management/constants/constant_strings.dart';
import 'package:school_management/constants/widgets/loading_stack_widget.dart';
import 'package:school_management/constants/widgets/scaffold_notification.dart';
import 'package:school_management/models/user_model.dart';
import 'package:school_management/pages/homepage/add_new_student_form.dart';

import '../../bloc/home/appBar/app_bar_bloc.dart';
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
          } else if (state is LoadingHomeState) {
            return Stack(children: [HomePageWidget(), LoadingStackWidget()]);
          } else if (state is SignOutSuccess) {
            return Stack(children: [HomePageWidget(), LoadingStackWidget()]);
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
            // // on sign-out we need to set Appbar bloc to initial state
            // context.read<AppBarBloc>().add(InitialAppBarEvent());
            context.go('/');
          }
        },
      ),
    );
  }
}

class HomePageWidget extends StatelessWidget {

  HomePageWidget({super.key, required});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BodyBloc(),
      child: BlocConsumer<BodyBloc, BodyState>(
        listener: (context, state) {
          if (state is ShowStudentFormState) {
            context.go('/homepage/add-student');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: HomePageAppBar.instance,
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<BodyBloc>().add(AddStudentEvent());
                },
                child: const Text(
                  StringConstants.addNewStudent,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
