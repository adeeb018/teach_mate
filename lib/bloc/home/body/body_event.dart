part of 'body_bloc.dart';

@immutable
sealed class BodyEvent {}

final class AddStudentEvent extends BodyEvent {}

final class RetrieveStudent extends BodyEvent {
  final String studentId;

  RetrieveStudent({required this.studentId});
}

final class SubmitStudentEvent extends BodyEvent {
  final GlobalKey<FormBuilderState> formKey;

  SubmitStudentEvent({required this.formKey});
}