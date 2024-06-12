part of 'competition_ranking_bloc.dart';

@immutable
sealed class CompetitionRankingState {}

final class CompetitionRankingInitial extends CompetitionRankingState {}

final class LoadingIsVisible extends CompetitionRankingState {}

final class LoadingIsNotVisible extends CompetitionRankingState {}

final class LoadRankingDataSuccess extends CompetitionRankingState {
  final List<CompetitionRanking> data;

  LoadRankingDataSuccess(this.data);
}

final class LoadRiddleDataFailed extends CompetitionRankingState {}
