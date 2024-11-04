import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/bloc/home/body/body_bloc.dart';
import 'package:school_management/bloc/student_edt/student_edit_bloc.dart';
import 'package:school_management/constants/widgets/scaffold_notification.dart';
import 'package:school_management/models/student_model.dart';

import '../../constants/widgets/loading_stack_widget.dart';
import 'homepage_appbar.dart';
import 'package:intl/intl.dart';

class StudentDetails extends StatefulWidget {
  final String id;

  // final Student student = Student(programmes: programmes, contact: contact, name: name, batch: batch, branch: branch, joiningDate: joiningDate)
  const StudentDetails({super.key, required this.id});

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formFeeKey = GlobalKey<FormBuilderState>();

  final List<String> branches = [
    'Computer',
    'Biology',
    'Commerce',
    'Humanities'
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BodyBloc>().add(RetrieveStudent(studentId: widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomePageAppBar.instance,
      body: BlocBuilder<BodyBloc, BodyState>(
        builder: (BuildContext context, state) {
          if (state is RetrieveStudentSuccess) {
            return detailsPage(state.student);
          } else {
            return detailsPage(null);
          }
        },
      ),
    );
  }

  Widget detailsPage(Student? student) {
    final TextEditingController dateController = TextEditingController(text: student?.disconDate?.toDate().toString());
    if (student == null) {
      return const LoadingStackWidget();
    }
    return Center(
      child: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(children: [
              // name field
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<StudentEditBloc, StudentEditState>(
                      builder: (context, state) {
                        return FormBuilderTextField(
                          autovalidateMode: AutovalidateMode.always,
                          name: 'name',
                          initialValue: student.name,
                          readOnly: state is EditNameState ? state.edit : true,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    context
                                        .read<StudentEditBloc>()
                                        .add(EditNameEvent(editEnable: true));
                                  },
                                  icon: Icon(Icons.edit)),
                              labelText: 'name',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            context
                                .read<StudentEditBloc>()
                                .add(EditNameEvent(editEnable: false));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              //contact field
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<StudentEditBloc, StudentEditState>(
                      builder: (context, state) {
                        return FormBuilderTextField(
                          autovalidateMode: AutovalidateMode.always,
                          name: 'contact',
                          initialValue: student.contact,
                          readOnly:
                              state is EditContactState ? state.edit : true,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    context.read<StudentEditBloc>().add(
                                        EditContactEvent(editEnable: true));
                                  },
                                  icon: Icon(Icons.edit)),
                              labelText: 'contact',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            context
                                .read<StudentEditBloc>()
                                .add(EditContactEvent(editEnable: false));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              // batch
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<StudentEditBloc, StudentEditState>(
                      builder: (context, state) {
                        return FormBuilderChoiceChip<String>(
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    context
                                        .read<StudentEditBloc>()
                                        .add(EditBatchEvent(editEnable: true));
                                  },
                                  icon: Icon(Icons.edit)),
                              labelText: 'Batch',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          alignment: WrapAlignment.end,
                          name: 'batch',
                          initialValue: student.batch,
                          enabled:
                              state is EditBatchState ? !(state.edit) : false,
                          onChanged: (_) {
                            context
                                .read<StudentEditBloc>()
                                .add(EditBatchEvent(editEnable: false));
                          },
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
                        );
                      },
                    ),
                  ),
                ],
              ),
              // branch
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<StudentEditBloc, StudentEditState>(
                      builder: (context, state) {
                        return FormBuilderDropdown<String>(
                          name: 'branch',
                          initialValue: student.branch,
                          enabled:
                              state is EditBranchState ? !(state.edit) : false,
                          onChanged: (val) {
                            context
                                .read<StudentEditBloc>()
                                .add(EditBranchEvent(editEnable: false));
                          },
                          decoration: InputDecoration(
                            labelText: 'Branch',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            suffix: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                context
                                    .read<StudentEditBloc>()
                                    .add(EditBranchEvent(editEnable: true));
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
                        );
                      },
                    ),
                  ),
                ],
              ),
              // programmes
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<StudentEditBloc, StudentEditState>(
                      builder: (context, state) {
                        return FormBuilderDropdown<String>(
                          name: 'programmes',
                          initialValue: student.programmes.keys.first,
                          enabled:
                              state is EditBranchState ? !(state.edit) : false,
                          onChanged: (val) {
                            context
                                .read<StudentEditBloc>()
                                .add(EditBranchEvent(editEnable: false));
                          },
                          decoration: InputDecoration(
                            labelText: 'programme',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            suffix: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                context
                                    .read<StudentEditBloc>()
                                    .add(EditBranchEvent(editEnable: true));
                              },
                            ),
                            hintText: 'select branch',
                          ),
                          items: student.programmes.keys
                              .map((programme) => DropdownMenuItem(
                                    alignment: AlignmentDirectional.center,
                                    value: programme,
                                    child: Text(programme),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // pay fees for selected programme
              ElevatedButton(
                onPressed: () async {
                  await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                Positioned(
                                  right: -40,
                                  top: -40,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                ),
                                FormBuilder(
                                    key: _formFeeKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FormBuilderTextField(
                                          readOnly: true,
                                          name: 'feeTotal',
                                          initialValue: student
                                              .programmes[_formKey.currentState!
                                                  .fields['programmes']?.value]
                                              ?.feeTotal
                                              .toString(),
                                          decoration: const InputDecoration(
                                              labelText: 'Total Fee',
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        FormBuilderTextField(
                                          readOnly: true,
                                          name: 'feeDue',
                                          initialValue: student
                                              .programmes[_formKey.currentState!
                                                  .fields['programmes']?.value]
                                              ?.feeDue
                                              .toString(),
                                          decoration: const InputDecoration(
                                              labelText: 'Fee Due',
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: BlocBuilder<
                                                  StudentEditBloc,
                                                  StudentEditState>(
                                                builder: (context, state) {
                                                  return FormBuilderTextField(
                                                    autovalidateMode:
                                                        AutovalidateMode.always,
                                                    name: 'feePaid',
                                                    initialValue: student
                                                        .programmes[_formKey
                                                            .currentState!
                                                            .fields[
                                                                'programmes']
                                                            ?.value]
                                                        ?.feePaid
                                                        .toString(),
                                                    readOnly: state
                                                            is EditFeePaidState
                                                        ? state.edit
                                                        : true,
                                                    decoration: InputDecoration(
                                                        suffixIcon: IconButton(
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      StudentEditBloc>()
                                                                  .add(EditFeePaidEvent(
                                                                      editEnable:
                                                                          true));
                                                            },
                                                            icon: Icon(
                                                                Icons.edit)),
                                                        labelText: 'fee Paid',
                                                        labelStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    onEditingComplete: () {
                                                      context
                                                          .read<
                                                              StudentEditBloc>()
                                                          .add(EditFeePaidEvent(
                                                              editEnable:
                                                                  false));
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: ElevatedButton(
                                            child: const Text('Done'),
                                            onPressed: () {
                                              // save current fee paid to student instance.
                                              double feePaid = double.tryParse(
                                                      _formFeeKey
                                                          .currentState!
                                                          .fields['feePaid']
                                                          ?.value) ??
                                                  0;
                                              context
                                                  .read<StudentEditBloc>()
                                                  .add(UpdateStudentFeeEvent(
                                                    val: feePaid,
                                                    formKey: _formKey,
                                                    student: student,
                                                  ));
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ));
                },
                child: const Text('Pay Due'),
              ),
              // remarks
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<StudentEditBloc, StudentEditState>(
                      builder: (context, state) {
                        return FormBuilderTextField(
                          autovalidateMode: AutovalidateMode.always,
                          name: 'remarks',
                          initialValue: student.remarks,
                          readOnly:
                              state is EditRemarkState ? state.edit : true,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    context
                                        .read<StudentEditBloc>()
                                        .add(EditRemarkEvent(editEnable: true));
                                  },
                                  icon: Icon(Icons.edit)),
                              labelText: 'remarks',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            context
                                .read<StudentEditBloc>()
                                .add(EditRemarkEvent(editEnable: false));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              // discontinue date
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Discontinue date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    // change discontinue logic here
                    student.disconDate = Timestamp.fromDate(selectedDate);
                    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                  }
                },

              ),
              SizedBox(height: 20,),
              // submit button
              ElevatedButton(
                  onPressed: () {
                    context.read<StudentEditBloc>().add(
                        SubmitDataEvent(formKey: _formKey, student: student));
                  },
                  child: Text('Submit')),
              BlocListener<StudentEditBloc, StudentEditState>(
                  listener: (context, state) {
                    if (state is UploadErrorState) {
                      ScaffoldSnackBar.of(context).show(state.error);
                    } else if (state is UploadSuccessState) {
                      context.go('/homepage');
                    }
                  },
                  child: SizedBox(),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
