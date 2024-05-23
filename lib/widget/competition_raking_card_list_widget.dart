import 'package:flutter/material.dart';
import 'package:riddlepedia/core/extension/double.dart';

class CompetitionCardList extends StatelessWidget {
  final String playerName;
  final int score;
  final int index;
  final Color backgoundColor;

  const CompetitionCardList(
      {super.key,
      required this.playerName,
      required this.score,
      required this.index, 
      this.backgoundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          10.0.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgoundColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(40.0 / 2),
                    ),
                    child: Text((index + 1).toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0))),
                12.0.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(playerName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                              textAlign: TextAlign.left),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Score",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.0,
                                    color: Colors.black),
                              ),
                              Text('$score',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.black))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          8.0.height
        ],
      ),
    );
  }
}
