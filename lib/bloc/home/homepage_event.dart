part of 'homepage_bloc.dart';

@immutable
sealed class HomepageEvent {}

final class InitialEvent extends HomepageEvent {}

final class SignOutEvent extends HomepageEvent {}

// final class AddStudentEvent extends HomepageEvent {}