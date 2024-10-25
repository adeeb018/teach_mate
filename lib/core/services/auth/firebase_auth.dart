import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:school_management/pages/homepage/homepage.dart';

import '../../../pages/loginPage/login_user.dart';


class Authentication {
  loginService() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginUser();
          }
        }
    );
  }

  static Future<UserCredential?> signUp(String emailID, String password) async {
    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailID, password: password);
      log('Logged in Successfully');

      // sign out immediately so that user can only login from login screen.
      await FirebaseAuth.instance.signOut();

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password' :
          log('The password provided is too weak.');
          break;
        case 'email-already-in-use' :
          log('The account already for that email.');
          break;
        default :
          log('Error in SignUp');
          break;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<UserCredential?> signIn(String emailID, String password) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailID, password: password);
      log('Logged In Successfully');
      return user;
    }on FirebaseAuthException catch (e) {
      log(e.toString());
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      log('SignOut Exception ${e.toString()}');
    }
  }

  Future<void> _signInWithGoogle() async {
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
      await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }
}