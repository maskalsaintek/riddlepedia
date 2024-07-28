part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class LoadingIsVisible extends HomeState {}

final class LoadingIsNotVisible extends HomeState {}

final class LoadRiddleDataSuccess extends HomeState {
  final List<Riddle> data;

  LoadRiddleDataSuccess(this.data);
}

final class LoadRiddleDataFailed extends HomeState {}
