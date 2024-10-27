part of 'body_bloc.dart';

@immutable
sealed class BodyEvent {}

final class AddStudentEvent extends BodyEvent {}