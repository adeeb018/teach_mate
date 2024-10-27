import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'body_event.dart';
part 'body_state.dart';

class BodyBloc extends Bloc<BodyEvent, BodyState> {
  BodyBloc() : super(BodyInitial()) {

    on<AddStudentEvent>((event, emit) {
      emit(ShowStudentFormState());
    });
  }
}
