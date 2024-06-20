part of 'create_riddle_bloc.dart';

@immutable
sealed class CreateRiddleState {}

final class CreateRiddleInitial extends CreateRiddleState {}

final class LoadingIsVisible extends CreateRiddleState {}

final class LoadCategoryDataSuccess extends CreateRiddleState {
  final List<RiddleCategory> data;
  final bool isPopBack;

  LoadCategoryDataSuccess(this.data, this.isPopBack);
}

final class LoadRiddleDataFailed extends CreateRiddleState {}
