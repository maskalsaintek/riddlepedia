part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class SubmitLoginEvent extends UserEvent {
  final String email;
  final String password;

  SubmitLoginEvent({required this.email, required this.password});
}

class FetchUserEvent extends UserEvent {}

class LogoutEvent extends UserEvent {}
