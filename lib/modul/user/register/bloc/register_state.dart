part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class LoadingIsVisible extends RegisterState {}

final class LoadingIsNotVisible extends RegisterState {}

final class RegisterSuccess extends RegisterState {}

final class RegisterFailed extends RegisterState {}
