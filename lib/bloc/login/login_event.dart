part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class AuthStateChangedEvent extends LoginEvent {
  final bool isAuthenticated;

  AuthStateChangedEvent(this.isAuthenticated);
}

class SignInEvent extends LoginEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class SignInWithGoogleEvent extends LoginEvent {}
