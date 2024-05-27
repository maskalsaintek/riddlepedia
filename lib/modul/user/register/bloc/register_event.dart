part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class SubmitRegisterEvent extends RegisterEvent {
  final String email;
  final String fullName;
  final String password;

  SubmitRegisterEvent(
      {required this.email, required this.fullName, required this.password});
}
