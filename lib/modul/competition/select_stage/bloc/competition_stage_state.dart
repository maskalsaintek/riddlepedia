part of 'competition_stage_bloc.dart';

@immutable
sealed class CompetitionStageState {}

final class CompetitionStageInitial extends CompetitionStageState {}

final class CompetitionStageCountResultState extends CompetitionStageState {
  final int count;
  final List<CompetitionStage> competitionStage;

  CompetitionStageCountResultState(this.count, this.competitionStage);
}

final class LoadingIsVisible extends CompetitionStageState {}

final class LoadingIsNotVisible extends CompetitionStageState {}
