import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/modul/user/bloc/user_bloc.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/widget/setting_menu_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  RpUser? _savedUser;

  @override
  void initState() {
    super.initState();

    context.read<UserBloc>().add(FetchUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserDataExist) {
            setState(() {
              _savedUser = state.user;
            });
          }
        },
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SettingMenu(
                        icon: Icons.person,
                        title: "Email",
                        subTitle: _savedUser?.email ?? "-",
                        isSufficIconVisible: false),
                    const SettingMenu(
                        icon: Icons.palette_outlined,
                        title: "Contest Rank",
                        subTitle: "-"),
                    const SettingMenu(
                        icon: Icons.history,
                        title: "Answered Riddle",
                        subTitle: "0 Riddles"),
                    InkWell(
                        onTap: () {
                          showPlatformDialog(
                    context: context,
                    builder: (context) => BasicDialogAlert(
                      title: const Text("Confirmation"),
                      content:
                          const Text("Are you sure want to log out?"),
                      actions: <Widget>[
                        BasicDialogAction(
                          title: const Text("No"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        BasicDialogAction(
                          title: const Text("Yes"),
                          onPressed: () {
                            context.read<UserBloc>().add(LogoutEvent());
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                          context.read<UserBloc>().add(FetchUserEvent());
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Column(
                          children: [
                            20.0.height,
                            Row(
                              children: [
                                const Icon(Icons.logout,
                                    color: AppColor.secondaryColor),
                                12.0.width,
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Logout",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.left)
                                  ],
                                )
                              ],
                            ),
                            10.0.height,
                            const Divider(thickness: 0.5)
                          ],
                        ))
                  ],
                ))));
  }
}
