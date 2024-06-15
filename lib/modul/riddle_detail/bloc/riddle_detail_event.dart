part of 'riddle_detail_bloc.dart';

@immutable
sealed class RiddleDetailEvent {}

class SetLoadingIsVisibleEvent extends RiddleDetailEvent {}

class FetchRiddleDataEvent extends RiddleDetailEvent {
  final int id;

  FetchRiddleDataEvent({required this.id});
}

class SubmitCompetitionDataEvent extends RiddleDetailEvent {
  final int riddleId;
  final int score;
  final int duration;
  final bool isCorrect;
  final RiddleDetail data;

  SubmitCompetitionDataEvent(
      {required this.riddleId,
      required this.score,
      required this.duration, 
      required this.isCorrect, 
      required this.data});
}
