import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  var logger = Logger();

  RegisterBloc() : super(RegisterInitial()) {
    on<SubmitRegisterEvent>((event, emit) async {
      emit(LoadingIsVisible());
      try {
        await Supabase.instance.client.from('user').insert({
          'create_by': event.email,
          'last_update_by': event.email,
          'email': event.email,
          'full_name': event.fullName,
          'password': event.password
        });
        emit(LoadingIsNotVisible());
        emit(RegisterSuccess());
      } catch (e) {
        logger.e("Error Submit Register. Error: $e");
        emit(LoadingIsNotVisible());
        emit(RegisterFailed());
      }
    });
  }
}
