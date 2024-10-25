import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:school_management/models/user_model.dart';
import 'package:school_management/utils/exceptions/validation_exceptions.dart';

import '../../core/usecases/sign_out_use_case.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  final SignOutUseCase _signOutUseCase;
  HomepageBloc() : _signOutUseCase = SignOutUseCase(FirebaseAuth.instance), super(HomepageInitial()) {

    on<SignOutEvent>((event, emit) async {
      emit(LoadingState());
      try {
        // sign out
        await _signOutUseCase.call();
        log('Signed out Successfully');
        // navigate to login screen
        emit(SignOutSuccess());
      } catch (e) {
        emit(SignOutError(error: e.toString()));
      }
    });
  }
}
