import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:school_management/models/student_model.dart';
import 'package:uuid/uuid.dart';

class DataBaseRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore db;
  final String? userId;
  DataBaseRepository({required this.firebaseAuth, required this.db}) : userId = firebaseAuth.currentUser?.uid;

  bool isInitialized(Student student) {
    try {
      // Attempt to access the field
      student.id;
      return true; // If no error, the field is initialized
    } catch (e) {
      return false; // If error, the field is not initialized
    }
  }

  Future<void> uploadStudentDetails(Student student) async {
    // final userId = firebaseAuth.currentUser?.uid;
    if (userId != null) {
      final userDoc = db.collection('users').doc(userId);
      // if student id is not initialized create one
      if(!(isInitialized(student))) {
        final Uuid uuid = Uuid();
        student.id = uuid.v4();
      }
      final studentRef = userDoc.collection('students').doc(student.id);

      try {
        // student.setId(id: studentId);
        // student.toJson().forEach((key, value) {
        //   debugPrint("$key , $value");
        // });
        await studentRef.set(student.toJson());
      } catch (e) {
        debugPrint(e.toString());
        throw Exception('Cannot store student');
      }
    } else {
      throw Exception('User is not authenticated');
    }
  }

  Future<Map<String, dynamic>?> fetchStudentFromDB(String studentId) async{
    if (userId != null) {
      final userDoc = db.collection('users').doc(userId);
      final studentRef = userDoc.collection('students').doc(studentId);

      try {
        // student.setId(id: studentId);
        // student.toJson().forEach((key, value) {
        //   debugPrint("$key , $value");
        // });
        final studentSnapshot = await studentRef.get();
        if(studentSnapshot.exists) {
          final student = studentSnapshot.data();
          debugPrint(student.toString());
          return student;
        }
      } catch (e) {
        debugPrint(e.toString());
        throw Exception('Cannot store student');
      }
    } else {
      throw Exception('User is not authenticated');
    }
    return null;
  }
}