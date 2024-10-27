
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'homepage.dart';
import 'homepage_appbar.dart';

class CreateNewStudent extends StatelessWidget {

  // final HomePageAppBar mySingleInstanceAppBar = HomePageAppBar(key: HomePage.homeAppBarKey);

  CreateNewStudent({super.key});

  // final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomePageAppBar.instance,
      body: Center(
          child: Text('hi')),
    );
  }
}
