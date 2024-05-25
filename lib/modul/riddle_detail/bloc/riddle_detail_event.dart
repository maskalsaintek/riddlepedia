part of 'riddle_detail_bloc.dart';

@immutable
sealed class RiddleDetailEvent {}

class SetLoadingIsVisibleEvent extends RiddleDetailEvent {}

class FetchRiddleDataEvent extends RiddleDetailEvent {
  final int id;

  FetchRiddleDataEvent({required this.id});
}
