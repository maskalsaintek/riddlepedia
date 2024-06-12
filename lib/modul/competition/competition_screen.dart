import 'package:flutter/cupertino.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/modul/competition/ranking/competition_ranking_screen.dart';
import 'package:riddlepedia/modul/competition/select_stage/competition_select_stage_screen.dart';
import 'package:riddlepedia/widget/rp_button_widget.dart';

class CompetitionScreen extends StatefulWidget {
  const CompetitionScreen({super.key});

  @override
  State<CompetitionScreen> createState() => _CompetitionScreen();
}

class _CompetitionScreen extends State<CompetitionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RpButton(
              title: "Start",
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const CompetitionSelectStageScreen()));
              }),
          22.0.height,
          RpButton(title: "Top Score", onPressed: () {
            Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const CompetitionRankingScreen()));
          })
        ],
      ),
    );
  }
}
