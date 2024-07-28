import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:riddlepedia/modul/competition/competition_screen.dart';
import 'package:riddlepedia/modul/home/bloc/home_bloc.dart';
import 'package:riddlepedia/modul/home/home_screen.dart';
import 'package:riddlepedia/modul/my_riddle/my_riddle_screen.dart';
import 'package:riddlepedia/modul/setting/setting_screen.dart';
import 'package:riddlepedia/modul/user/bloc/user_bloc.dart';
import 'package:riddlepedia/modul/user/login/login_screen.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/modul/user/profile/profile_screen.dart';
import 'package:riddlepedia/util/app_localizations.dart';
import 'package:riddlepedia/util/preference_util.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final RpUser? savedBiometricUser;

  const MainScreen({super.key, this.savedBiometricUser});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  String _screenTitle = "Riddlepedia";
  bool _isLogin = true;
  final _tabTitle = ["home", "my_riddle", "Contest", "Login"];
  RpUser? _savedBiometricUser;

  @override
  void initState() {
    super.initState();

    _screenTitle = AppLocalizations.instance.translate('home');
    _savedBiometricUser = widget.savedBiometricUser;
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
              onPressed: () async {
                final RpUser? savedUser = await PreferenceUtil.get<RpUser?>(
                    'user', (json) => RpUser.fromJson(json));
                final RpUser? savedBiometricUser =
                    await PreferenceUtil.get<RpUser?>(
                        'biometric_user', (json) => RpUser.fromJson(json));
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => SettingScreen(
                            savedLocale: prefs.getString('savedLocale') ?? "en",
                            savedUser: savedUser,
                            savedBiometricUser: savedBiometricUser)));
                            setState(() {
                              _screenTitle = AppLocalizations.instance.translate(_tabTitle[1]);
                            });
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
                    _screenTitle = !_isLogin ? "Profile" : AppLocalizations.instance.translate('login');
                    context.read<UserBloc>().add(FetchUserEvent());
                    return;
                  }
                  if (index == 2) {
                    _screenTitle = !_isLogin ? "Contest" : AppLocalizations.instance.translate('login');
                    context.read<UserBloc>().add(FetchUserEvent());
                    return;
                  }
                  _screenTitle = AppLocalizations.instance.translate(_tabTitle[index]);
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
                  text: AppLocalizations.instance.translate("my_riddle"),
                  icon: const Icon(Icons.dashboard),
                ),
                Tab(
                  text: AppLocalizations.instance.translate("contest"),
                  icon: const Icon(Symbols.trophy),
                ),
                Tab(
                  text: AppLocalizations.instance.translate("profile"),
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
              BlocListener<UserBloc, UserState>(listener: (context, state) async {
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
                    _screenTitle = "Profile";
                  });
                }

                if (state is UserDataNotFound) {
                  setState(() {
                    _isLogin = true;
                  });
                }

                if (state is LogoutSuccess) {
                  _savedBiometricUser =
                    await PreferenceUtil.get<RpUser?>(
                        'biometric_user', (json) => RpUser.fromJson(json));
                  setState(() {
                    _isLogin = true;
                    _screenTitle = AppLocalizations.instance.translate('login');
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
                !_isLogin
                    ? const ProfileScreen()
                    : LoginScreen(savedBiometricUser: _savedBiometricUser)
              ],
            ),
          )),
    ));
  }
}
