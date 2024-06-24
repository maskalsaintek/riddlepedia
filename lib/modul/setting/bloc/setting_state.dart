part of 'setting_bloc.dart';

@immutable
sealed class SettingState {}

final class SettingInitial extends SettingState {}

class LocaleLoaded extends SettingState {
  final Locale locale;

  LocaleLoaded(this.locale);
}
