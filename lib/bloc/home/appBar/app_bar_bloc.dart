import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../models/user_model.dart';
import '../../../utils/exceptions/validation_exceptions.dart';

part 'app_bar_event.dart';
part 'app_bar_state.dart';

class AppBarBloc extends Bloc<AppBarEvent, AppBarState> {
  AppBarBloc() : super(AppBarInitial()) {

    on<LoadProfile>((event, emit) async{
      try {
        //get data from fireStore about profile information
        final UserModel? userData = await _getProfileInfoFromDB();
        emit(ProfileLoaded(userData: userData));

      } catch (e) {
        emit(LoadError(error: e.toString()));
      }
    });
  }

  Future<UserModel?> _getProfileInfoFromDB() async {
    final db = FirebaseFirestore.instance;
    final docRef =
    db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid);
    return docRef.get().then(
          (DocumentSnapshot doc) {
        final data = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        log("Data Retrieved from FireStore:- ${data.toMap().toString()}");
        return data;
      },
      onError: (e) => throw FireStoreException(e.toString()),
    );
  }
}
