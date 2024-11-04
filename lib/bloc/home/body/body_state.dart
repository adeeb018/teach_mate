part of 'body_bloc.dart';

@immutable
sealed class BodyState {}

final class BodyInitial extends BodyState {}

final class ShowStudentFormState extends BodyState {}

final class StudentCreationSuccess extends BodyState {
  final String id;

  StudentCreationSuccess({required this.id});
}

final class StudentCreationFailed extends BodyState {
  final String error;

  StudentCreationFailed({required this.error});
}

final class RetrieveStudentLoading extends BodyState {}

final class RetrieveStudentSuccess extends BodyState {
  final Student student;

  RetrieveStudentSuccess({required this.student});
}

final class RetrieveStudentFailed extends BodyState {
  final String error;

  RetrieveStudentFailed({required this.error});
}


