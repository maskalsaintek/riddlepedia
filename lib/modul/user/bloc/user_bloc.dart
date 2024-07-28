import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/modul/user/profile/model/user_rank_model.dart';
import 'package:riddlepedia/util/app_localizations.dart';
import 'package:riddlepedia/util/preference_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  var logger = Logger();

  UserBloc() : super(UserInitial()) {
    on<SubmitLoginEvent>((event, emit) async {
      emit(UserLoadingIsVisible());
      try {
        final response = await Supabase.instance.client
            .from('user')
            .select()
            .eq('email', event.email)
            .eq('password', event.password) // Compare password
            .single();
        RpUser? user = RpUser.fromJson(response);
        logger.d(response);
        emit(UserLoadingIsNotVisible());
        await PreferenceUtil.save('user', user);
        emit(LoginSuccess());
      } catch (e) {
        logger.e("Error Submit Login. Error: $e");
        emit(UserLoadingIsNotVisible());
        emit(LoginFailed(
            error: AppLocalizations.instance
                .translate("invalid_email_or_password")));
      }
    });

    on<SubmitLoginFacebookEvent>((event, emit) async {
      emit(UserLoadingIsVisible());
      try {
        final response = await Supabase.instance.client
            .from('user')
            .upsert({
              'id': event.id,
              'full_name': event.name,
              'email': event.email,
              'password': 'fb-type',
              'create_by': event.email,
              'last_update_by': event.email
            })
            .select()
            .single();
        RpUser? user = RpUser.fromJson(response);
        logger.d(response);
        emit(UserLoadingIsNotVisible());
        await PreferenceUtil.save('user', user);
        emit(LoginSuccess());
      } catch (e) {
        logger.e("Error Submit Login. Error: $e");
        emit(UserLoadingIsNotVisible());
        emit(LoginFailed(
            error: AppLocalizations.instance
                .translate("invalid_email_or_password")));
      }
    });

    on<FetchUserEvent>((event, emit) async {
      emit(UserLoadingIsVisible());
      RpUser? savedUser = await PreferenceUtil.get<RpUser?>(
          'user', (json) => RpUser.fromJson(json));
      logger.d(savedUser);
      if (savedUser != null) {
        try {
          final rankingResponse = await Supabase.instance.client
              .rpc<List<dynamic>>('get_user_ranking',
                  params: {'p_user_id': savedUser!.id});
          List<UserRank> rankData = rankingResponse
              .map((json) => UserRank.fromJson(json as Map<String, dynamic>))
              .toList();
          final String rank = rankData.isEmpty ? '-' : '${rankData.first.rank}';
          final countResponse = await Supabase.instance.client
              .from('competition_entry')
              .select()
              .eq('user_id', savedUser!.id)
              .count(CountOption.exact);
          emit(UserLoadingIsNotVisible());
          emit(UserDataExist(
              user: savedUser,
              rank: rank,
              answeredRiddle: '${countResponse.data.length}'));
        } catch (e) {
          logger.e("Error fetch Riddle Detail. Error: $e");
          emit(UserLoadingIsNotVisible());
          emit(UserDataNotFound());
        }
      } else {
        emit(UserLoadingIsNotVisible());
        emit(UserDataNotFound());
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(UserLoadingIsVisible());
      await PreferenceUtil.remove("user");
      emit(UserLoadingIsNotVisible());
      emit(LogoutSuccess());
    });

    on<SubmiBiometrictLoginEvent>((event, emit) async {
      emit(UserLoadingIsVisible());
      try {
        RpUser? savedBiometricUser = await PreferenceUtil.get<RpUser?>(
            'biometric_user', (json) => RpUser.fromJson(json));
        emit(UserLoadingIsNotVisible());
        await PreferenceUtil.save('user', savedBiometricUser);
        emit(LoginSuccess());
      } catch (e) {
        logger.e("Error Submit Login. Error: $e");
        emit(UserLoadingIsNotVisible());
        emit(LoginFailed(
            error: AppLocalizations.instance
                .translate("invalid_email_or_password")));
      }
    });
  }
}
