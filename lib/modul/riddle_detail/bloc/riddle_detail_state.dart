part of 'riddle_detail_bloc.dart';

@immutable
sealed class RiddleDetailState {}

final class RiddleDetailInitial extends RiddleDetailState {}

final class LoadingIsVisible extends RiddleDetailState {}

final class LoadingIsNotVisible extends RiddleDetailState {}

final class LoadRiddleDataSuccess extends RiddleDetailState {
  final RiddleDetail data;
  final bool isPopBack;

  LoadRiddleDataSuccess(this.data, this.isPopBack);
}

final class LoadRiddleDataFailed extends RiddleDetailState {}
