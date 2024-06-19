import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:riddlepedia/modul/home/model/riddle_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  var logger = Logger();
  
  HomeBloc() : super(HomeInitial()) {
    on<FetchRiddleDataEvent>((event, emit) async {
      final response = await Supabase.instance.client
          .from("riddle")
          .select()
          .eq('record_flag', 'active')
          .range(event.offset, event.offset + event.limit - 1);

      try {
        final data = response as List<dynamic>;
        List<Riddle> riddleData = data
            .map((json) => Riddle.fromJson(json as Map<String, dynamic>))
            .toList();
        emit(LoadingIsNotVisible());
        emit(LoadRiddleDataSuccess(event.currentData + riddleData));
      } catch (e) {
        logger.e("Error fetch Riddle List. Error: $e");
        emit(LoadingIsNotVisible());
        emit(LoadRiddleDataFailed());
      }
    });

    on<SetLoadingIsVisibleEvent>((event, emit) async {
      emit(LoadingIsVisible());
    });
  }
}
