part of 'app_bar_bloc.dart';

@immutable
sealed class AppBarState {}

final class AppBarInitial extends AppBarState {}

final class ProfileLoaded extends AppBarState {
  final UserModel? userData;

  ProfileLoaded({required this.userData});
}

final class LoadError extends AppBarState {
  final String error;

  LoadError({required this.error});
}
