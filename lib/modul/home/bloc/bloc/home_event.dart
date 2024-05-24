part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class SetLoadingIsVisibleEvent extends HomeEvent {}

class FetchRiddleDataEvent extends HomeEvent {
  final int limit;
  final int offset;
  final List<Riddle> currentData;

  FetchRiddleDataEvent(
      {required this.limit, required this.offset, required this.currentData});
}
