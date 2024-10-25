
import 'package:firebase_auth/firebase_auth.dart';

class SignOutUseCase {
  final FirebaseAuth _firebaseAuth;

  SignOutUseCase(this._firebaseAuth);

  Future<void> call() async {
    await _firebaseAuth.signOut();
  }
}