import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:riddlepedia/modul/my_riddle/model/riddle_category.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/util/preference_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'create_riddle_event.dart';
part 'create_riddle_state.dart';

class CreateRiddleBloc extends Bloc<CreateRiddleEvent, CreateRiddleState> {
  var logger = Logger();

  CreateRiddleBloc() : super(CreateRiddleInitial()) {
    on<SetLoadingIsVisibleEvent>((event, emit) async {
      emit(LoadingIsVisible());
    });

    on<SubmitRiddleEvent>((event, emit) async {
      RpUser? savedUser = await PreferenceUtil.get<RpUser?>(
          'user', (json) => RpUser.fromJson(json));
      final riddleInsertResponse = await Supabase.instance.client
          .from("riddle")
          .insert({
            "create_by": savedUser!.email,
            "last_update_by": savedUser!.email,
            "title": event.title,
            "description": event.description,
            "answer": event.answer,
            "difficulty": event.level,
            "type": "riddle",
            "author_id": savedUser!.id,
            "category_id": event.categoryId,
            "hint1": event.hint1,
            "hint2": event.hint2,
            "hint3": event.hint3,
            "record_flag": "waiting_approval"
          })
          .select()
          .single();

      await Supabase.instance.client.from("option").insert({
        "create_by": savedUser!.email,
        "last_update_by": savedUser!.email,
        "riddle_id": riddleInsertResponse["id"],
        "description": event.option1,
      });

      await Supabase.instance.client.from("option").insert({
        "create_by": savedUser!.email,
        "last_update_by": savedUser!.email,
        "riddle_id": riddleInsertResponse["id"],
        "description": event.option2,
      });

      await Supabase.instance.client.from("option").insert({
        "create_by": savedUser!.email,
        "last_update_by": savedUser!.email,
        "riddle_id": riddleInsertResponse["id"],
        "description": event.option3,
      });

      await Supabase.instance.client.from("option").insert({
        "create_by": savedUser!.email,
        "last_update_by": savedUser!.email,
        "riddle_id": riddleInsertResponse["id"],
        "description": event.option4,
      });

      emit(LoadCategoryDataSuccess(event.data, true));
    });

    on<FetchCategoryDataEvent>((event, emit) async {
      final categoryResponse =
          await Supabase.instance.client.from("category").select();

      try {
        final categoryData = categoryResponse as List<dynamic>;
        List<RiddleCategory> riddleCategoryData = categoryData
            .map(
                (json) => RiddleCategory.fromJson(json as Map<String, dynamic>))
            .toList();
        emit(LoadCategoryDataSuccess(riddleCategoryData, false));
      } catch (e) {
        logger.e("Error fetch Riddle List. Error: $e");
        emit(LoadRiddleDataFailed());
      }
    });
  }
}
