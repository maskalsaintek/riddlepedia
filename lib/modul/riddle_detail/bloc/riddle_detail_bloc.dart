import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:riddlepedia/modul/riddle_detail/model/riddle_detail_model.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/util/preference_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'riddle_detail_event.dart';
part 'riddle_detail_state.dart';

class RiddleDetailBloc extends Bloc<RiddleDetailEvent, RiddleDetailState> {
  var logger = Logger();

  RiddleDetailBloc() : super(RiddleDetailInitial()) {
    on<FetchRiddleDataEvent>((event, emit) async {
      final response = await Supabase.instance.client.rpc<List<dynamic>>(
          'fetch_riddle_details',
          params: {'input_riddle_id': event.id});

      try {
        logger.d(response);
        List<RiddleDetail> riddleData = response
            .map((json) => RiddleDetail.fromJson(json as Map<String, dynamic>))
            .toList();
        emit(LoadingIsNotVisible());
        emit(LoadRiddleDataSuccess(riddleData.first, false));
      } catch (e) {
        logger.e("Error fetch Riddle Detail. Error: $e");
        emit(LoadingIsNotVisible());
        emit(LoadRiddleDataFailed());
      }
    });

    on<SubmitCompetitionDataEvent>((event, emit) async {
      RpUser? savedUser = await PreferenceUtil.get<RpUser?>(
          'user', (json) => RpUser.fromJson(json));
      final response =
          await Supabase.instance.client.from('competition_entry').upsert({
        'user_id': savedUser!.id,
        'riddle_id': event.riddleId,
        'duration': event.duration,
        'is_correct': event.isCorrect,
        'score': event.score,
        'create_by': savedUser!.email,
        'last_update_by': savedUser!.email,
        'record_flag': 'active'
      });
      logger.d(response);
      emit(LoadRiddleDataSuccess(event.data, true));
    });

    on<SetLoadingIsVisibleEvent>((event, emit) async {
      emit(LoadingIsVisible());
    });
  }
}
