part of 'my_riddle_bloc.dart';

@immutable
sealed class MyRiddleState {}

final class MyRiddleInitial extends MyRiddleState {}

final class LoadingIsVisible extends MyRiddleState {}

final class LoadRiddleDataSuccess extends MyRiddleState {
  final List<Riddle> data;
  final List<RiddleCategory> categoryData;

  LoadRiddleDataSuccess(this.data, this.categoryData);
}

final class LoadRiddleDataFailed extends MyRiddleState {}
