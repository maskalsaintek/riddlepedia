part of 'setting_bloc.dart';

@immutable
sealed class SettingEvent {}

class LocaleChanged extends SettingEvent {
  final Locale locale;

  LocaleChanged(this.locale);
}
