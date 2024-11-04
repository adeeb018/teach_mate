import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:meta/meta.dart';
import 'package:school_management/core/repositories/database_repository.dart';
import 'package:uuid/uuid.dart';

import '../../../models/student_model.dart';

part 'body_event.dart';
part 'body_state.dart';

class BodyBloc extends Bloc<BodyEvent, BodyState> {
  BodyBloc() : super(BodyInitial()) {

    on<AddStudentEvent>((event, emit) {
      emit(ShowStudentFormState());
    });

    on<SubmitStudentEvent>(_mapSubmitStudentEventToState);
    on<RetrieveStudent>((event, emit) async {
      try {
        emit(RetrieveStudentLoading());
        await Future.delayed(Duration(seconds: 4));
        final DataBaseRepository db = DataBaseRepository(firebaseAuth: FirebaseAuth.instance, db: FirebaseFirestore.instance);
        final studentJson = await db.fetchStudentFromDB(event.studentId);
        emit(RetrieveStudentSuccess(student: Student.fromJson(studentJson!)));
      } catch (e) {
        emit(RetrieveStudentFailed(error: e.toString()));
      }
    });
  }

  Future<FutureOr<void>>_mapSubmitStudentEventToState(SubmitStudentEvent event, Emitter<BodyState> emit) async {
    try {
      final formData = Map<String, dynamic>.from(event.formKey.currentState!.value);

      final Map<String, Programme> programmeDetails = {
        "Crash": Programme(feeDue: 500, feeTotal: 500, feePaid: 0),
        "Regular": Programme(feeDue: 1000, feeTotal: 1000, feePaid: 0),
        "Night": Programme(feeDue: 750, feeTotal: 750, feePaid: 0),
      };

      Map<String, Programme> selectedProgrammes = {
        for (var programmeName in formData['programmes'])
          programmeName: programmeDetails[programmeName]!
      };

      Student student = Student(
        name: formData['name'] ?? '',
        contact: formData['contact'] ?? '',
        batch: formData['batch'] ?? '',
        branch: formData['branch'] ?? '',
        programmes: selectedProgrammes,
        feeTotal: double.tryParse(formData['feeTotal'] ?? '0') ?? 0,
        feeDue: double.tryParse(formData['feeTotal'] ?? '0') ?? 0, // on creating feeDue is same as fee total
        remarks: formData['remarks'] ?? '',
        joiningDate: Timestamp.now(),
      );

      // debugPrint(student.toJson().toString());
      // store data to fire-store
      // await _uploadStudentDetails(student);
      final DataBaseRepository db = DataBaseRepository(firebaseAuth: FirebaseAuth.instance, db: FirebaseFirestore.instance);
      await db.uploadStudentDetails(student);
      // debugPrint('StudentId is ${student.id}');
      emit(StudentCreationSuccess(id: student.id));
    } catch (e) {
      emit(StudentCreationFailed(error: e.toString()));
    }
  }

  // _uploadStudentDetails(Student student) async {
//   try {
//     // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//     // final db = FirebaseFirestore.instance;
//     // final userId = firebaseAuth.currentUser?.uid;
//     // final Uuid uuid = Uuid();
//     //
//     // if (userId != null) {
//     //   final userDoc = db.collection('users').doc(userId);
//     //   final studentId = uuid.v4();
//     //   final studentRef = userDoc.collection('students').doc(studentId);
//     //
//     //   try {
//     //     // student.setId(id: studentId);
//     //     await studentRef.set(student.toJson()
//     //       ..['id'] = studentId);
//     //   } catch (e) {
//     //     throw Exception('Cannot store student');
//     //   }
//     // } else {
//     //   throw Exception('User is not authenticated');
//     // }
//   } catch (e) {
//     throw Exception('Uploading Student Details Failed');
//   }
// }
}
