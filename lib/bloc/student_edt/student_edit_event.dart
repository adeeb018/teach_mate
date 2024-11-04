part of 'student_edit_bloc.dart';

@immutable
sealed class StudentEditEvent {}

final class EditNameEvent extends StudentEditEvent {
  final bool editEnable;

  EditNameEvent({required this.editEnable});
}
final class EditContactEvent extends StudentEditEvent {
  final bool editEnable;

  EditContactEvent({required this.editEnable});
}
final class EditBatchEvent extends StudentEditEvent {
  final bool editEnable;

  EditBatchEvent({required this.editEnable});
}
final class EditBranchEvent extends StudentEditEvent {
  final bool editEnable;

  EditBranchEvent({required this.editEnable});
}
final class EditFeePaidEvent extends StudentEditEvent {
  final bool editEnable;

  EditFeePaidEvent({required this.editEnable});
}
final class UpdateStudentFeeEvent extends StudentEditEvent {
  final double val;
  final GlobalKey<FormBuilderState> formKey;
  final Student student;
  UpdateStudentFeeEvent({required this.student, required this.val, required this.formKey});
}
final class EditRemarkEvent extends StudentEditEvent {
  final bool editEnable;

  EditRemarkEvent({required this.editEnable});
}
final class SubmitDataEvent extends StudentEditEvent {
  final Student student;
  final GlobalKey<FormBuilderState> formKey;

  SubmitDataEvent({required this.student, required this.formKey});
}
