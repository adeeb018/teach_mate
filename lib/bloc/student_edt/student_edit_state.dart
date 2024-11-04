part of 'student_edit_bloc.dart';

@immutable
sealed class StudentEditState {}

final class StudentEditInitial extends StudentEditState {}

final class EditNameState extends StudentEditState {
  final bool edit;

  EditNameState({required this.edit});
}
final class EditContactState extends StudentEditState {
  final bool edit;

  EditContactState({required this.edit});
}
final class EditBatchState extends StudentEditState {
  final bool edit;

  EditBatchState({required this.edit});
}
final class EditBranchState extends StudentEditState {
  final bool edit;

  EditBranchState({required this.edit});
}
final class EditFeePaidState extends StudentEditState {
  final bool edit;

  EditFeePaidState({required this.edit});
}
final class EditRemarkState extends StudentEditState {
  final bool edit;

  EditRemarkState({required this.edit});
}
final class SubmitDataState extends StudentEditState {
  final bool edit;

  SubmitDataState({required this.edit});
}

final class UploadSuccessState extends StudentEditState {}

final class UploadErrorState extends StudentEditState {
  final String error;

  UploadErrorState({required this.error});
}
