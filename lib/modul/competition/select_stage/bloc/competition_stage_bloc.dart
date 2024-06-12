import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
        final response = await Supabase.instance.client
            .from('competition')
            .count(CountOption.exact);
        logger.d(response);
        emit(CompetitionStageCountResultState(response));
      } catch (e) {
        logger.e("Error fetch Riddle Detail. Error: $e");
        emit(LoadingIsNotVisible());
      }
    });
  }
}
