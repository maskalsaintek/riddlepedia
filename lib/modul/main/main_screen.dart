import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:riddlepedia/modul/home/home_screen.dart';
import 'package:riddlepedia/modul/my_riddle/my_riddle_screen.dart';
import 'package:riddlepedia/modul/setting/setting_screen.dart';
import 'package:riddlepedia/modul/user/login/login_screen.dart';
import 'package:riddlepedia/modul/user/profile/profile_screen.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  String _screenTitle = "Riddlepedia";
  bool _isLogin = true;
  final _tabTitle = ["Home", "My Riddle", "Contest", "Login"];

  @override
  void initState() {
    super.initState();

    _screenTitle = _tabTitle[0];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: RpAppBar(title: _screenTitle, actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Setting',
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const SettingScreen()));
              },
            ),
          ]),
          bottomNavigationBar: Container(
            color: AppColor.mainColor,
            child: TabBar(
              labelColor: Colors.white,
              labelPadding: EdgeInsets.zero,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (index) {
                setState(() {
                  if (index == 3) {
                    _isLogin = !_isLogin;
                  }
                  _screenTitle = index == 3 ? (_isLogin ? "Profile" : "Login") : _tabTitle[index];
                });
              },
              indicator: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: AppColor.indicatorColor, width: 6.0))),
              tabs: [
                Tab(
                  text: _tabTitle[0],
                  icon: const Icon(Icons.home),
                ),
                Tab(
                  text: _tabTitle[1],
                  icon: const Icon(Icons.dashboard),
                ),
                Tab(
                  text: _tabTitle[2],
                  icon: const Icon(Symbols.trophy),
                ),
                const Tab(
                  text: "Profile",
                  icon: Icon(Icons.person),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              const HomeScreen(),
              const MyRiddleScreen(),
              const Icon(Symbols.trophy),
              _isLogin ? const ProfileScreen() : const LoginScreen()
            ],
          )),
    ));
  }
}
