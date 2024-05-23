import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/modul/riddle_detail/riddle_detail_screen.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:riddlepedia/widget/competition_raking_card_list_widget.dart';

class CompetitionRankingScreen extends StatefulWidget {
  const CompetitionRankingScreen({super.key});

  @override
  State<CompetitionRankingScreen> createState() => _CompetitionRankingScreen();
}

class _CompetitionRankingScreen extends State<CompetitionRankingScreen> {
  @override
  void initState() {
    super.initState();
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
          body: Container(
              color: Colors.grey[300],
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                itemCount: 15,
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
                      playerName: "John Doe", score: 1146, index: index, backgoundColor: backgoundColor);
                },
              ))),
    );
  }
}
