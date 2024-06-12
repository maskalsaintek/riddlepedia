part of 'competition_stage_bloc.dart';

@immutable
sealed class CompetitionStageState {}

final class CompetitionStageInitial extends CompetitionStageState {}

final class CompetitionStageCountResultState extends CompetitionStageState {
  final int count;

  CompetitionStageCountResultState(this.count);
}

final class LoadingIsVisible extends CompetitionStageState {}

final class LoadingIsNotVisible extends CompetitionStageState {}
