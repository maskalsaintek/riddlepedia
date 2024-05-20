import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riddlepedia/widget/riddle_card_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[300],
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          itemCount: 15,
          itemBuilder: (context, index) {
            return RiddleCardList(
                title: "Judul",
                description:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                icon: Icons.spa, 
                index: index);
          },
        ));
  }
}
