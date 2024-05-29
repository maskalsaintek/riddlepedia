part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoadingIsVisible extends UserState {}

final class UserLoadingIsNotVisible extends UserState {}

class LoginSuccess extends UserState {}

class LogoutSuccess extends UserState {}

class UserDataExist extends UserState {
  final RpUser user;

  UserDataExist({required this.user});
}

class UserDataNotFound extends UserState {}

class LoginFailed extends UserState {
  final String error;

  LoginFailed({required this.error});
}
