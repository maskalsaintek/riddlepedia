import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:riddlepedia/modul/competition/ranking/bloc/competition_ranking_bloc.dart';
import 'package:riddlepedia/modul/competition/select_stage/bloc/competition_stage_bloc.dart';
import 'package:riddlepedia/modul/home/bloc/bloc/home_bloc.dart';
import 'package:riddlepedia/modul/riddle_detail/bloc/riddle_detail_bloc.dart';
import 'package:riddlepedia/modul/user/bloc/user_bloc.dart';
import 'package:riddlepedia/modul/user/register/bloc/register_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'modul/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://notwjmvrcasrcsakvlrz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vdHdqbXZyY2FzcmNzYWt2bHJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY0OTI4NjgsImV4cCI6MjAzMjA2ODg2OH0.WroqS1vfDaPSD37SkWVsU3rce4fwPHBKcfn5FCkMjt0',
  );
  await Future.delayed(const Duration(seconds: 2));
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => RiddleDetailBloc()),
        BlocProvider(create: (context) => RegisterBloc()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => CompetitionStageBloc()),
        BlocProvider(create: (context) => CompetitionRankingBloc())
      ],
      child: MaterialApp(
          title: "Riddlepedia",
          home: const MainScreen(),
          builder: EasyLoading.init())));
}
