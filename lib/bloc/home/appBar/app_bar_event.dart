part of 'app_bar_bloc.dart';

@immutable
sealed class AppBarEvent {}

final class LoadProfile extends AppBarEvent {}
