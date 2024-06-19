import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';

class RiddleCardList extends StatelessWidget {
  final String title;
  final String description;
  final String level;
  final double rating;
  final int index;
  final String imageUrl;

  const RiddleCardList(
      {super.key,
      required this.title,
      required this.description,
      required this.level,
      required this.rating,
      required this.index,
      required this.imageUrl});

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 4,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Image.network(imageUrl)),
                12.0.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                  textAlign: TextAlign.left)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RatingBarIndicator(
                                  rating: rating,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemSize: 15,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 0.5),
                                  itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      )),
                              Text(
                                  level == "active"
                                      ? "Approved"
                                      : level == "rejected"
                                          ? "Rejected"
                                          : level == "waiting_approval"
                                              ? "In Review"
                                              : level,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.0,
                                      color: level == "Hard" ||
                                              level == "rejected"
                                          ? Colors.red[700]
                                          : level == "Normal" ||
                                                  level == "waiting_approval"
                                              ? Colors.orange
                                              : level == "active"
                                                  ? Colors.green
                                                  : AppColor.secondaryColor))
                            ],
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        width: MediaQuery.of(context).size.width -
                            (20 * 2) -
                            (16 * 2) -
                            75,
                        child: Text(
                          description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13.0,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 3,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          10.0.height
        ],
      ),
    );
  }
}
