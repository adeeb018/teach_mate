import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:school_management/constants/constant_strings.dart';
import 'package:school_management/core/services/auth/auth_validator.dart';
import 'package:school_management/core/usecases/registeration_use_case.dart';
import 'package:school_management/core/usecases/sign_out_use_case.dart';
import 'package:school_management/models/user_model.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseAuth _firebaseAuth;
  final RegisterUseCase _registerUseCase;
  final SignOutUseCase _signOutUseCase;

  factory RegisterBloc() {
    return RegisterBloc._(FirebaseAuth.instance);
  }

  RegisterBloc._(this._firebaseAuth)
      : _registerUseCase = RegisterUseCase(_firebaseAuth),
        _signOutUseCase = SignOutUseCase(_firebaseAuth),
        super(RegisterInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      emit(LoadingState());
      try {
        // validate email
        Validator.validateEmail(event.email);
        // validate password
        Validator.validatePassword(event.password);
        // register user
        await _registerUseCase.call(event.email, event.password);
        // save the user_model in fireStore
        await _registerUseCase.storeUserdata(event.name, event.email);
        // A sign out is required else authState will not be null
        await _signOutUseCase.call();
        log('User Registered Successfully');
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailed(error: e.toString()));
      }
    });
  }
}
