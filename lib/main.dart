import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:riddlepedia/modul/competition/ranking/bloc/competition_ranking_bloc.dart';
import 'package:riddlepedia/modul/competition/select_stage/bloc/competition_stage_bloc.dart';
import 'package:riddlepedia/modul/home/bloc/bloc/home_bloc.dart';
import 'package:riddlepedia/modul/my_riddle/bloc/my_riddle_bloc.dart';
import 'package:riddlepedia/modul/my_riddle/create_riddle/bloc/create_riddle_bloc.dart';
import 'package:riddlepedia/modul/riddle_detail/bloc/riddle_detail_bloc.dart';
import 'package:riddlepedia/modul/setting/bloc/setting_bloc.dart';
import 'package:riddlepedia/modul/user/bloc/user_bloc.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/modul/user/register/bloc/register_bloc.dart';
import 'package:riddlepedia/util/preference_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'modul/main/main_screen.dart';
import 'package:riddlepedia/util/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://notwjmvrcasrcsakvlrz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vdHdqbXZyY2FzcmNzYWt2bHJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY0OTI4NjgsImV4cCI6MjAzMjA2ODg2OH0.WroqS1vfDaPSD37SkWVsU3rce4fwPHBKcfn5FCkMjt0',
  );
  await Future.delayed(const Duration(seconds: 2));
  String savedLocale = 'en';
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    savedLocale = prefs.getString('savedLocale') ?? 'en';
  } catch (e) {
    savedLocale = 'en';
  }
  
  final RpUser? savedBiometricUser = await PreferenceUtil.get<RpUser?>(
      'biometric_user', (json) => RpUser.fromJson(json));
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => RiddleDetailBloc()),
        BlocProvider(create: (context) => RegisterBloc()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => CompetitionStageBloc()),
        BlocProvider(create: (context) => CompetitionRankingBloc()),
        BlocProvider(create: (context) => MyRiddleBloc()),
        BlocProvider(create: (context) => CreateRiddleBloc()),
        BlocProvider(create: (context) => SettingBloc())
      ],
      child: BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
        Locale locale;
        if (state is LocaleLoaded) {
          locale = state.locale;
        } else {
          locale = Locale(savedLocale);
        }
        return MaterialApp(
            title: "Riddlepedia",
            home: MainScreen(savedBiometricUser: savedBiometricUser),
            builder: EasyLoading.init(),
            themeMode: ThemeMode.light,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            theme: ThemeData(
                primarySwatch: Colors.blue,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.dark,
                ),
                buttonTheme: const ButtonThemeData(
                  buttonColor: Colors.blue, // Default button color
                )));
      })));
}
