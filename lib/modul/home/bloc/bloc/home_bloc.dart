import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:riddlepedia/modul/home/model/riddle_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchRiddleDataEvent>((event, emit) async {
      final response = await Supabase.instance.client
          .from("riddle")
          .select()
          .range(event.offset, event.offset + event.limit - 1);

      final data = response as List<dynamic>;
      List<Riddle> riddleData = data
          .map((json) => Riddle.fromJson(json as Map<String, dynamic>))
          .toList();
      emit(LoadingIsNotVisible());
      emit(LoadRiddleDataSuccess(event.currentData + riddleData));
    });

    on<SetLoadingIsVisibleEvent>((event, emit) async {
      emit(LoadingIsVisible());
    });
  }
}
