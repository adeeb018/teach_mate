
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';
import '../../utils/exceptions/validation_exceptions.dart';

class RegisterUseCase {
  final FirebaseAuth _firebaseAuth;

  RegisterUseCase(this._firebaseAuth);

  Future<void> call(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> storeUserdata(String name, String email) async {
    // save the user_model in fireStore
    // we need to check for user if already exist in fireStore
    final db = FirebaseFirestore.instance;
    final userId = _firebaseAuth.currentUser?.uid;

    if (userId != null) {
      final userDoc = db.collection('users').doc(userId);
      final userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        // user doesn't exist
        final user = UserModel(id: DateTime.now().millisecondsSinceEpoch, name: name, email: email);
        await userDoc.set(user.toMap());
      } else {
        // User already exists, so don't add again
        log('User already exists in FireStore.');
      }
    } else {
      throw Exception('User is not authenticated');
    }
  }
}