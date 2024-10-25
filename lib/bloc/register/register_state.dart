part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class LoadingState extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final String message;

  RegisterSuccess() : message = StringConstants.userRegisteredSuccess;
}

final class RegisterFailed extends RegisterState {
  final String error;

  RegisterFailed({required this.error});
}
