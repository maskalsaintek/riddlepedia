import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:riddlepedia/modul/competition/select_stage/model/competition_stage_model.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/util/preference_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/web.dart';

part 'competition_stage_event.dart';
part 'competition_stage_state.dart';

class CompetitionStageBloc
    extends Bloc<CompetitionStageEvent, CompetitionStageState> {
  var logger = Logger();

  CompetitionStageBloc() : super(CompetitionStageInitial()) {
    on<FetchRiddleStageDataCountEvent>((event, emit) async {
      emit(LoadingIsVisible());

      try {
        RpUser? savedUser = await PreferenceUtil.get<RpUser?>(
          'user', (json) => RpUser.fromJson(json));
        final response = await Supabase.instance.client.rpc<List<dynamic>>(
            'get_riddle_entries',
            params: {'user_id_param': savedUser!.id});
        logger.d(response);
        List<CompetitionStage> stageData = response
            .map((json) =>
                CompetitionStage.fromJson(json as Map<String, dynamic>))
            .toList();
        emit(CompetitionStageCountResultState(response.length, stageData));
      } catch (e) {
        logger.e("Error fetch Riddle Detail. Error: $e");
        emit(LoadingIsNotVisible());
      }
    });
  }
}
