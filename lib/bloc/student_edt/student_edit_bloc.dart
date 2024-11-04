import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:meta/meta.dart';
import 'package:school_management/core/repositories/database_repository.dart';

import '../../models/student_model.dart';

part 'student_edit_event.dart';
part 'student_edit_state.dart';

class StudentEditBloc extends Bloc<StudentEditEvent, StudentEditState> {
  StudentEditBloc() : super(StudentEditInitial()) {
    on<StudentEditEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<EditNameEvent>((event, emit) => emit(EditNameState(edit: !(event.editEnable))));
    on<EditContactEvent>((event, emit) => emit(EditContactState(edit: !(event.editEnable))));
    on<EditBatchEvent>((event, emit) => emit(EditBatchState(edit: !(event.editEnable))));
    on<EditBranchEvent>((event, emit) => emit(EditBranchState(edit: !(event.editEnable))));
    on<EditFeePaidEvent>((event, emit) => emit(EditFeePaidState(edit: !(event.editEnable))));
    on<UpdateStudentFeeEvent>((event, emit) {
      event.student.programmes[event.formKey.currentState!.fields['programmes']?.value]?.feePaid = event.val;
    });
    on<EditRemarkEvent>((event, emit) => emit(EditRemarkState(edit: !(event.editEnable))));
    on<SubmitDataEvent>((event, emit) async{
      try {
        // change edited form details to student instance
        // :- name
        event.student.name = event.formKey.currentState!.fields['name']!.value;
        // :- contact
        event.student.contact = event.formKey.currentState!.fields['contact']!.value;
        // :- batch
        event.student.batch = event.formKey.currentState!.fields['batch']!.value;
        // :- branch
        event.student.branch = event.formKey.currentState!.fields['branch']!.value;
        // :- remarks
        event.student.remarks = event.formKey.currentState!.fields['remarks']!.value;
        // :- discontinue data
        // event.student.disconDate = event.formKey.currentState!.fields['disconDate']?.value;
        // update total fee paid
        _updatePaidFee(event.student);
        debugPrint(event.student.toJson().toString());
        // upload to firestore with corresponding id.
        final DataBaseRepository db = DataBaseRepository(firebaseAuth: FirebaseAuth.instance, db: FirebaseFirestore.instance);
        await db.uploadStudentDetails(event.student);
        emit(UploadSuccessState());
      } catch (e) {
        emit(UploadErrorState(error: e.toString()));
      }
    });
  }

  _updatePaidFee(Student student) {
    double totalFeePaid = 0;
    student.programmes.forEach((key, value) {
      totalFeePaid += value.feePaid;
    });
    student.feePaid = totalFeePaid;
  }
}
