import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
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
        emit(LoginFailed(error: "Invalid Email or Password"));
      }
    });

    on<SubmitLoginFacebookEvent>((event, emit) async {
      emit(UserLoadingIsVisible());
      try {
        final response = await Supabase.instance.client.from('user').upsert({
          'id': event.id,
          'full_name': event.name,
          'email': event.email,
          'password': 'fb-type',
          'create_by': event.email,
          'last_update_by': event.email
        }).select().single();
        RpUser? user = RpUser.fromJson(response);
        logger.d(response);
        emit(UserLoadingIsNotVisible());
        await PreferenceUtil.save('user', user);
        emit(LoginSuccess());
      } catch (e) {
        logger.e("Error Submit Login. Error: $e");
        emit(UserLoadingIsNotVisible());
        emit(LoginFailed(error: "Invalid Email or Password"));
      }
    });

    on<FetchUserEvent>((event, emit) async {
      emit(UserLoadingIsVisible());
      RpUser? savedUser = await PreferenceUtil.get<RpUser?>(
          'user', (json) => RpUser.fromJson(json));
      emit(UserLoadingIsNotVisible());
      logger.d(savedUser);
      if (savedUser != null) {
        emit(UserDataExist(user: savedUser));
      } else {
        emit(UserDataNotFound());
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(UserLoadingIsVisible());
      await PreferenceUtil.remove("user");
      emit(UserLoadingIsNotVisible());
      emit(LogoutSuccess());
    });
  }
}
