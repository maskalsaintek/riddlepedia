import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Riddlepedia'),
            backgroundColor: AppColor.mainColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Setting',
                onPressed: () async {},
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: AppColor.mainColor,
            child: const TabBar(
              labelColor: Colors.white,
              labelPadding: EdgeInsets.zero,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.orange, width: 6.0))),
              tabs: [
                Tab(
                  text: "Home",
                  icon: Icon(Icons.home),
                ),
                Tab(
                  text: "My Riddle",
                  icon: Icon(Icons.dashboard),
                ),
                Tab(
                  text: "Contest",
                  icon: Icon(Symbols.trophy),
                ),
                Tab(
                  text: "Profile",
                  icon: Icon(Icons.person),
                )
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.home),
              Icon(Icons.dashboard),
              Icon(Symbols.trophy),
              Icon(Icons.person)
            ],
          )),
    ));
  }
}
