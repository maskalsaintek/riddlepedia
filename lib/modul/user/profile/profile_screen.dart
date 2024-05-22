import 'package:flutter/material.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/widget/setting_menu_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SettingMenu(
                    icon: Icons.person,
                    title: "Username",
                    subTitle: "budi.gunawan@gmail.com",
                    isSufficIconVisible: false),
                const SettingMenu(
                    icon: Icons.palette_outlined,
                    title: "Contest Rank",
                    subTitle: "137"),
                const SettingMenu(
                    icon: Icons.history,
                    title: "Answered Riddle",
                    subTitle: "23 Riddles"),
                InkWell(
                    onTap: () {},
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
            )));
  }
}
