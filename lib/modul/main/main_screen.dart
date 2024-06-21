import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:riddlepedia/modul/competition/competition_screen.dart';
import 'package:riddlepedia/modul/home/bloc/bloc/home_bloc.dart';
import 'package:riddlepedia/modul/home/home_screen.dart';
import 'package:riddlepedia/modul/my_riddle/my_riddle_screen.dart';
import 'package:riddlepedia/modul/setting/setting_screen.dart';
import 'package:riddlepedia/modul/user/bloc/user_bloc.dart';
import 'package:riddlepedia/modul/user/login/login_screen.dart';
import 'package:riddlepedia/modul/user/profile/profile_screen.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
                    _screenTitle = !_isLogin ? "Profile" : "Login";
                    context.read<UserBloc>().add(FetchUserEvent());
                    return;
                  }
                  if (index == 2) {
                    _screenTitle = !_isLogin ? "Contest" : "Login";
                    context.read<UserBloc>().add(FetchUserEvent());
                    return;
                  }
                  _screenTitle = _tabTitle[index];
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
          body: MultiBlocListener(
            listeners: [
              BlocListener<HomeBloc, HomeState>(listener: (context, state) {
                if (state is LoadRiddleDataFailed) {
                  showPlatformDialog(
                    context: context,
                    builder: (context) => BasicDialogAlert(
                      title: const Text("Information"),
                      content:
                          const Text("There is something wrong in our system."),
                      actions: <Widget>[
                        BasicDialogAction(
                          title: const Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                }
              }),
              BlocListener<UserBloc, UserState>(listener: (context, state) {
                if (state is LoginFailed) {
                  showPlatformDialog(
                    context: context,
                    builder: (context) => BasicDialogAlert(
                      title: const Text("Information"),
                      content: Text(state.error),
                      actions: <Widget>[
                        BasicDialogAction(
                          title: const Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );

                  setState(() {
                    _isLogin = true;
                  });
                }

                if (state is UserLoadingIsVisible) {
                  EasyLoading.show(
                      status: 'Loading...',
                      maskType: EasyLoadingMaskType.black);
                }

                if (state is UserLoadingIsNotVisible) {
                  EasyLoading.dismiss();
                }

                if (state is LoginSuccess) {
                  setState(() {
                    _isLogin = false;
                  });
                }

                if (state is UserDataNotFound) {
                  setState(() {
                    _isLogin = true;
                  });
                }

                if (state is LogoutSuccess) {
                  setState(() {
                    _isLogin = true;
                  });
                }

                if (state is UserDataExist) {
                  setState(() {
                    _isLogin = false;
                  });
                }
              })
            ],
            child: TabBarView(
              children: [
                const HomeScreen(),
                !_isLogin ? const MyRiddleScreen() : const LoginScreen(),
                !_isLogin ? const CompetitionScreen() : const LoginScreen(),
                !_isLogin ? const ProfileScreen() : const LoginScreen()
              ],
            ),
          )),
    ));
  }
}
