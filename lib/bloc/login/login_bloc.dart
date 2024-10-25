import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:school_management/core/usecases/sign_in_use_case.dart';

import '../../core/services/auth/auth_validator.dart';
import '../../core/usecases/sign_in_with_google.dart';
import '../../models/user_model.dart';
import '../../utils/exceptions/validation_exceptions.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _firebaseAuth;
  final SignInUseCase _signInUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  factory LoginBloc() {
    return LoginBloc._(FirebaseAuth.instance);
  }

  LoginBloc._(this._firebaseAuth)
      : _signInUseCase = SignInUseCase(_firebaseAuth),
        _signInWithGoogleUseCase = SignInWithGoogleUseCase(_firebaseAuth),
        super(LoginInitial()) {
    on<SignInEvent>(_onSignIn);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
  }

  _onSignIn(event, emit) async {
    try {
      emit(LoadingState());
      // validate email
      Validator.validateEmail(event.email);
      // validate password
      Validator.validatePassword(event.password);
      // firebase sign in
      await _signInUseCase.call(event.email, event.password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailed(error: e.toString()));
    }
  }

  _onSignInWithGoogle(event, emit) async {
    try {
      emit(LoadingState());
      await _signInWithGoogleUseCase.call();
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailed(error: e.toString()));
    }
  }
}
