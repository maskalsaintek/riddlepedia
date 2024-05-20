import 'package:flutter/material.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/widget/riddle_card_list_widget.dart';

class MyRiddleScreen extends StatefulWidget {
  const MyRiddleScreen({super.key});

  @override
  State<MyRiddleScreen> createState() => _MyRiddleScreen();
}

class _MyRiddleScreen extends State<MyRiddleScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[300],
        child: Column(children: [
          Container(
            margin: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black38),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black38),
                      ),
                    ),
                  ),
                  ),
                ),
                8.0.width,
                SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: const Icon(Icons.filter_list,
                            color: AppColor.secondaryColor))),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              return RiddleCardList(
                  title: "Judul",
                  description:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  icon: Icons.spa,
                  index: index);
            },
          )),
          Container(
            margin: EdgeInsets.all(20.0),
            height: 44,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(6)),
            child: TextButton(
                onPressed: () {},
                child: const Text("Create Riddle",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14))),
          )
        ]));
  }
}
