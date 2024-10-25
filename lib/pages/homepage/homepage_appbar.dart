import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home/appBar/app_bar_bloc.dart';
import '../../bloc/home/homepage_bloc.dart';
import '../../constants/widgets/scaffold_notification.dart';
import '../../models/user_model.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return homePageAppBar(context);
  }

  AppBar homePageAppBar(BuildContext context) {
    UserModel? userData;
    return AppBar(
      backgroundColor: Colors.blue,
      title: Center(child: const Text('Welcome')),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: BlocProvider(
            create: (context) => AppBarBloc()..add(LoadProfile()),
            child: BlocConsumer<AppBarBloc, AppBarState>(
              builder: (context, state) {
                // if (state is AppBarInitial && userData == null) {
                //   context.read<AppBarBloc>().add(LoadProfile());
                // }
                return _dropdown(context, userData);
              },
              listener: (context, state) {
                if (state is ProfileLoaded) {
                  userData = state.userData;
                } else if (state is LoadError) {
                  ScaffoldSnackBar.of(context).show(state.error);
                }
              },
            ),
          ),

        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            onPressed: () {
              context.read<HomepageBloc>().add(SignOutEvent());
            },
            icon: const Icon(
              Icons.logout_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  // user profile drop down page
  Widget _dropdown(BuildContext context, UserModel? userData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.person_2_rounded,
          size: 20,
          color: Colors.white,
        ),
        // openWithLongPress: true,
        items: [
          DropdownMenuItem(
            value: 'name',
            child: dropDownItems("name : ", userData?.name),
          ),
          // const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
          DropdownMenuItem(
            value: 'email',
            child: dropDownItems("email : ", userData?.email),
          ),
        ],
        onChanged: (value) {
          // MenuItems.onChanged(context, value! as MenuItem);
        },
        buttonStyleData: ButtonStyleData(
          // This is necessary for the ink response to match our customButton radius.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.blue,
          ),
          offset: const Offset(40, -4),
        ),
      ),
    );
  }

  Widget dropDownItems(String content, String? data) {
    return Row(
      children: [
        Text(
          content,
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(width: 10),
        Text(
          data ?? 'Not available',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}