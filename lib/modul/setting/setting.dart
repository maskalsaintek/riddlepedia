import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/widget/setting_menu_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text("Setting"),
                backgroundColor: AppColor.mainColor,
                foregroundColor: Colors.white,
                leading: BackButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      SystemNavigator.pop();
                    }
                  },
                )),
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        20.0.height,
                        const SettingMenu(
                            icon: Icons.language_outlined,
                            title: "Language",
                            subTitle: "English"),
                        20.0.height,
                        const SettingMenu(
                            icon: Icons.palette_outlined,
                            title: "Theme",
                            subTitle: "Light"),
                        20.0.height,
                        const SettingMenu(
                            icon: Icons.fingerprint_outlined,
                            title: "Biometric Login",
                            subTitle: "Login with fingerprint and face id"),
                        20.0.height,
                        const SettingMenu(
                            icon: Icons.question_answer_outlined,
                            title: "FAQ",
                            subTitle: "Frequently Asked Questions"),
                        20.0.height,
                        const SettingMenu(
                            icon: Icons.info_outline,
                            title: "About",
                            subTitle: "Riddlepedia Information")
                      ],
                    )))));
  }
}
