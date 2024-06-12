import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:riddlepedia/modul/competition/ranking/model/competition_ranking.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/web.dart';

part 'competition_ranking_event.dart';
part 'competition_ranking_state.dart';

class CompetitionRankingBloc extends Bloc<CompetitionRankingEvent, CompetitionRankingState> {
  var logger = Logger();

  CompetitionRankingBloc() : super(CompetitionRankingInitial()) {
    on<FetchCompetitionRankingEvent>((event, emit) async {
      final response = await Supabase.instance.client
          .rpc<List<dynamic>>('get_user_scores');

      try {
        logger.d(response);
        List<CompetitionRanking> data = response
            .map((json) => CompetitionRanking.fromJson(json as Map<String, dynamic>))
            .toList();
        emit(LoadingIsNotVisible());
        emit(LoadRankingDataSuccess(data));
      } catch (e) {
        logger.e("Error fetch Riddle Detail. Error: $e");
        emit(LoadingIsNotVisible());
        emit(LoadRiddleDataFailed());
      }
    });
  }
}
