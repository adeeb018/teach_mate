
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:school_management/core/usecases/registeration_use_case.dart';
import 'package:school_management/utils/exceptions/validation_exceptions.dart';

class SignInWithGoogleUseCase {
  final FirebaseAuth _firebaseAuth;

  SignInWithGoogleUseCase(this._firebaseAuth);

  Future<void> call() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      final UserCredential userCredential = await _firebaseAuth.signInWithPopup(authProvider);
      // Add user data to fireStore
      if(userCredential.user?.displayName == null || userCredential.user?.email == null) {
        throw ValidationException('No name or email to display');
      } else {
        final displayName = userCredential.user!.displayName!;
        final email = userCredential.user!.email!;
        RegisterUseCase(_firebaseAuth).storeUserdata(displayName, email);
      }
    } else {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        await _firebaseAuth.signInWithCredential(credential);
      }
    }
  }
}