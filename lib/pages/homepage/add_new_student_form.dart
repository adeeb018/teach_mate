
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/bloc/home/body/body_bloc.dart';
import 'package:school_management/constants/widgets/scaffold_notification.dart';
import 'package:school_management/models/student_model.dart';

import 'homepage_appbar.dart';

class CreateNewStudent extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  CreateNewStudent({super.key});

  final List<String> branches = [
    'Computer',
    'Biology',
    'Commerce',
    'Humanities'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomePageAppBar.instance,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: [
                  BlocListener<BodyBloc, BodyState>(
                    listener: (context, state) {
                      if (state is StudentCreationSuccess) {
                        ScaffoldSnackBar.of(context).show('Student Created Successfully');
                        context.go(Uri(
                          path: '/homepage/add-student/student-details',
                          queryParameters: {'id': state.id},
                        ).toString());

                      } else if (state is StudentCreationFailed) {
                        ScaffoldSnackBar.of(context).show(state.error);
                      }
                    },
                    child: studentForm(context),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FormBuilder studentForm(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.always,
              name: 'name',
              decoration: const InputDecoration(
                  labelText: 'name',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.always,
              name: 'contact',
              decoration: const InputDecoration(
                  labelText: 'contact',
                  hintText: 'phone',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            FormBuilderChoiceChip<String>(
              onChanged: (val) {
                // updateTotalFee();
              },
              decoration: const InputDecoration(
                  labelText: 'Batch',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              alignment: WrapAlignment.end,
              name: 'batch',
              // initialValue: 'Dart',
              options: const [
                FormBuilderChipOption(
                  value: '+2',
                ),
                FormBuilderChipOption(
                  value: '+1',
                ),
                FormBuilderChipOption(
                  value: '10',
                ),
                FormBuilderChipOption(
                  value: '9',
                ),
                FormBuilderChipOption(
                  value: '8',
                ),
              ],
            ),
            FormBuilderDropdown<String>(
              name: 'branch',
              initialValue: 'Biology',
              onChanged: (val) {
                // updateTotalFee();
              },
              decoration: InputDecoration(
                labelText: 'Branch',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                suffix: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _formKey.currentState!.fields['branch']?.reset();
                  },
                ),
                hintText: 'select branch',
              ),
              items: branches
                  .map((branch) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: branch,
                        child: Text(branch),
                      ))
                  .toList(),
            ),
            FormBuilderCheckboxGroup<String>(
              decoration: const InputDecoration(
                labelText: 'Programme',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              name: 'programmes',
              options: const [
                FormBuilderFieldOption(value: 'Crash'),
                FormBuilderFieldOption(value: 'Regular'),
                FormBuilderFieldOption(value: 'Night'),
              ],
              onChanged: (programSelections) {
                updateTotalFee();
              },
              separator: const VerticalDivider(
                width: 10,
                thickness: 5,
                color: Colors.red,
              ),
            ),
            FormBuilderTextField(
              readOnly: true,
              name: 'feeTotal',
              // initialValue: 0,
              decoration: const InputDecoration(
                  labelText: 'Total Fee',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.always,
              name: 'remarks',
              decoration: const InputDecoration(
                  labelText: 'Remarks',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          context
                              .read<BodyBloc>()
                              .add(SubmitStudentEvent(formKey: _formKey));
                        }
                        // else {
                        //   debugPrint(_formKey.currentState?.value.toString());
                        //   debugPrint('validation failed');
                        // }
                      },
                      child: const Text('Submit')),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                    },
                    // color: Theme.of(context).colorScheme.secondary,
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  // void updateFeeDue() {
  //   final double paidFee = double.tryParse(_formKey.currentState!.fields['feePaid']?.value ?? '0') ?? 0;
  //   final double totalFee = double.tryParse(_formKey.currentState!.fields['feeTotal']?.value ?? '0') ?? 0;
  //
  //   final double feeDue = totalFee - paidFee;
  //
  //   // Update the 'feeDue' field with the calculated value
  //   if (feeDue >= 0) {
  //     _formKey.currentState!.fields['feeDue']?.didChange(feeDue.toString());
  //   }
  // }

  // Method to calculate feeTotal
  void updateTotalFee() {
    // Get values from all factors affecting the feeTotal
    // final double batchValue = _getBatchValue(_formKey.currentState!.fields['batch']?.value);
    // final double branchValue = _getBranchValue(_formKey.currentState!.fields['branch']?.value);
    final double programValue =
        _getProgramValue(_formKey.currentState!.fields['programmes']?.value);

    // Calculate feeTotal based on all factors
    final double totalFee = programValue;

    // Update the 'feeTotal' field with the calculated value
    _formKey.currentState!.fields['feeTotal']?.didChange(totalFee.toString());
  }

// Helper function to get the batch value based on the selected option
  double _getBatchValue(String? batchSelection) {
    switch (batchSelection) {
      case '+2':
        return 500;
      case '+1':
        return 400;
      case '10':
        return 300;
      case '9':
        return 200;
      case '8':
        return 100;
      default:
        return 10;
    }
  }

  double _getBranchValue(String? branchSelection) {
    switch (branchSelection) {
      case 'Biology':
        return 500;
      case 'Computer':
        return 400;
      case 'Commerce':
        return 300;
      case 'Humanities':
        return 200;
      default:
        return 10;
    }
  }

  double _getProgramValue(List<String?>? programSelection) {
    if (programSelection == null) {
      return 0;
    }
    if (programSelection.isEmpty) {
      return 0;
    } else if (programSelection.contains('Crash') &&
        programSelection.contains('Regular') &&
        programSelection.contains('Night')) {
      return 2250;
    } else if (programSelection.contains('Crash') &&
        programSelection.contains('Regular')) {
      return 1500;
    } else if (programSelection.contains('Crash') &&
        programSelection.contains('Night')) {
      return 1250;
    } else if (programSelection.contains('Night') &&
        programSelection.contains('Regular')) {
      return 1750;
    } else if (programSelection.contains('Crash')) {
      return 500;
    } else if (programSelection.contains('Regular')) {
      return 1000;
    } else if (programSelection.contains('Night')) {
      return 750;
    }
    return 0;
  }
}
