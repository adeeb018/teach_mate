part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoadingState extends LoginState {}

class LoginSuccess extends LoginState {}

final class LoginFailed extends LoginState {
  final String error;

  LoginFailed({required this.error});
}

final class DatabaseError extends LoginState {
  final String error;

  DatabaseError({required this.error});
}


