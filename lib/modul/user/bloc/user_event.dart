part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class SubmitLoginEvent extends UserEvent {
  final String email;
  final String password;

  SubmitLoginEvent({required this.email, required this.password});
}

class SubmiBiometrictLoginEvent extends UserEvent {}

class SubmitLoginFacebookEvent extends UserEvent {
  final String email;
  final String name;
  final int id;

  SubmitLoginFacebookEvent({required this.email, required this.name, required this.id});
}

class FetchUserEvent extends UserEvent {}

class LogoutEvent extends UserEvent {}
