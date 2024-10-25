part of 'homepage_bloc.dart';

@immutable
sealed class HomepageState {}

final class HomepageInitial extends HomepageState {}

final class LoadingState extends HomepageState {}

// final class AddStudentState extends HomepageState {}

final class SignOutSuccess extends HomepageState {}

final class SignOutError extends HomepageState {
  final String error;

  SignOutError({required this.error});
}





