part of 'body_bloc.dart';

@immutable
sealed class BodyState {}

final class BodyInitial extends BodyState {}

final class ShowStudentFormState extends BodyState {}
