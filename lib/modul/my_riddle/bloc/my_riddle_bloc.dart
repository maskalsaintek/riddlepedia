import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:riddlepedia/modul/home/model/riddle_model.dart';
import 'package:riddlepedia/modul/my_riddle/model/riddle_category.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/util/preference_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'my_riddle_event.dart';
part 'my_riddle_state.dart';

class MyRiddleBloc extends Bloc<MyRiddleEvent, MyRiddleState> {
  var logger = Logger();

  MyRiddleBloc() : super(MyRiddleInitial()) {
    on<SetLoadingIsVisibleEvent>((event, emit) async {
      emit(LoadingIsVisible());
    });

    on<FetchRiddleDataEvent>((event, emit) async {
      RpUser? savedUser = await PreferenceUtil.get<RpUser?>(
          'user', (json) => RpUser.fromJson(json));
      final keyword = event.keyword ?? '';
      var query = Supabase.instance.client
          .from("riddle")
          .select()
          .eq('author_id', savedUser!.id)
          .ilike('title', '%$keyword%');

      if (event.startDate != null) {
        query = query.gte('created_at', event.startDate!.toIso8601String());
      }

      if (event.endDate != null) {
        query = query.lte('created_at', event.endDate!.toIso8601String());
      }

      if (event.approvalStatus != null && event.approvalStatus! != 'All') {
        String recordFlag;

        switch (event.approvalStatus!) {
          case 'Approved':
            recordFlag = 'active';
            break;

          case 'Rejected':
            recordFlag = 'rejected';
            break;

          default:
            recordFlag = 'waiting_approval';
        }

        query = query.eq('record_flag', recordFlag);
      }

      if (event.categoryId != null && event.categoryId != '-1') {
        query = query.eq('category_id', int.parse(event.categoryId!));
      }

      final response =
          await query.range(event.offset, event.offset + event.limit - 1);

      final categoryResponse =
          await Supabase.instance.client.from("category").select();

      try {
        final data = response as List<dynamic>;
        final categoryData = categoryResponse as List<dynamic>;
        List<Riddle> riddleData = data
            .map((json) => Riddle.fromJson(json as Map<String, dynamic>))
            .toList();
        List<RiddleCategory> riddleCategoryData = categoryData
            .map(
                (json) => RiddleCategory.fromJson(json as Map<String, dynamic>))
            .toList();
        emit(LoadRiddleDataSuccess(
            event.currentData + riddleData, riddleCategoryData));
      } catch (e) {
        logger.e("Error fetch Riddle List. Error: $e");
        emit(LoadRiddleDataFailed());
      }
    });
  }
}
