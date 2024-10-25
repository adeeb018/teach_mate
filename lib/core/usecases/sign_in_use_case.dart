
import 'package:firebase_auth/firebase_auth.dart';

class SignInUseCase {
  final FirebaseAuth _firebaseAuth;

  SignInUseCase(this._firebaseAuth);

  Future<void> call(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }
}
