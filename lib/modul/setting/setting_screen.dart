import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/modul/webview/webview_screen.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
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
            appBar: RpAppBar(
                title: "Setting",
                appBarType: RpAppBarType.back,
                onClosePageButtonPressen: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                }),
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SettingMenu(
                            icon: Icons.language_outlined,
                            title: "Language",
                            subTitle: "English",
                            onPressed: () {
                              _showChooseLanguageActionSheet(context);
                            }),
                        SettingMenu(
                            icon: Icons.palette_outlined,
                            title: "Theme",
                            subTitle: "Light",
                            onPressed: () {
                              _showChooseThemeActionSheet(context);
                            }),
                        const SettingMenu(
                            icon: Icons.fingerprint_outlined,
                            title: "Biometric Login",
                            subTitle: "Login with fingerprint and face id"),
                        SettingMenu(
                            icon: Icons.question_answer_outlined,
                            title: "FAQ",
                            subTitle: "Frequently Asked Questions",
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => const WebviewScreen(
                                          title: "FAQ",
                                          url:
                                              "https://maskalsaintek.github.io/riddlepedia-faq-page/")));
                            }),
                        SettingMenu(
                            icon: Icons.info_outline,
                            title: "About Us",
                            subTitle: "Riddlepedia Version 1.0 Information",
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => const WebviewScreen(
                                          title: "About Us",
                                          url:
                                              "https://maskalsaintek.github.io/riddlepedia-about.github.io/")));
                            })
                      ],
                    )))));
  }

  void _showChooseLanguageActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Choose Language'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('English'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Bahasa'),
          )
        ],
      ),
    );
  }

  void _showChooseThemeActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Choose Theme'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Light'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Dark'),
          )
        ],
      ),
    );
  }
}
