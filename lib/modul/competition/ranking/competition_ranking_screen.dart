import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/modul/competition/ranking/bloc/competition_ranking_bloc.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:riddlepedia/widget/competition_raking_card_list_widget.dart';
import 'package:riddlepedia/constants/app_color.dart';

class CompetitionRankingScreen extends StatefulWidget {
  const CompetitionRankingScreen({super.key});

  @override
  State<CompetitionRankingScreen> createState() => _CompetitionRankingScreen();
}

class _CompetitionRankingScreen extends State<CompetitionRankingScreen> {
  @override
  void initState() {
    super.initState();

    context.read<CompetitionRankingBloc>().add(FetchCompetitionRankingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: RpAppBar(
              title: "Contest Ranking",
              appBarType: RpAppBarType.back,
              onClosePageButtonPressen: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              }),
          body: BlocListener<CompetitionRankingBloc, CompetitionRankingState>(
              listener: (context, state) {},
              child:
                  BlocBuilder<CompetitionRankingBloc, CompetitionRankingState>(
                      builder: (contex, state) {
                if (state is LoadingIsVisible) {
                  return Center(
                      child: SizedBox(
                          width: 100,
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: AppColor.secondaryColor, size: 75))));
                }

                if (state is LoadRankingDataSuccess) {
                  return Container(
                    color: Colors.grey[300],
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        Color backgoundColor;

                        switch (index) {
                          case 0:
                            backgoundColor = Color(0xFFFFD700);
                          case 1:
                            backgoundColor = Color(0xFFC0C0C0);
                          case 2:
                            backgoundColor = Color(0xFFCD7F32);
                          default:
                            backgoundColor = Colors.white;
                        }

                        return CompetitionCardList(
                            playerName: state.data[index].fullName,
                            score: state.data[index].totalScore,
                            index: index,
                            backgoundColor: backgoundColor);
                      },
                    ));
                }
                return Container();
              }))),
    );
  }
}
