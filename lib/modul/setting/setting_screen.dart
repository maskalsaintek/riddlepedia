import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:logger/web.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/modul/webview/webview_screen.dart';
import 'package:riddlepedia/util/preference_util.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:riddlepedia/widget/setting_menu_widget.dart';
import 'package:local_auth/local_auth.dart';

class SettingScreen extends StatefulWidget {
  final RpUser? savedUser;
  final RpUser? savedBiometricUser;

  const SettingScreen({super.key, this.savedUser, this.savedBiometricUser});

  @override
  State<SettingScreen> createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  var logger = Logger();
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isBiometricActivated = false;

  @override
  void initState() {
    super.initState();
    _isBiometricActivated = widget.savedBiometricUser != null;
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
                        if (widget.savedUser != null)
                          SettingMenu(
                              icon: Icons.fingerprint_outlined,
                              title: "Biometric Login",
                              subTitle: _isBiometricActivated
                                  ? "Biometric Authentication is Activated"
                                  : "Login with fingerprint and face id",
                              onPressed: () async {
                                if (_isBiometricActivated) {
                                  showPlatformDialog(
                                    context: context,
                                    builder: (context) => BasicDialogAlert(
                                      title: const Text("Information"),
                                      content: const Text(
                                          "Biometric has beem activated"),
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
                                  return;
                                }

                                List<BiometricType> availableBiometrics =
                                    await _auth.getAvailableBiometrics();

                                if (Platform.isIOS) {
                                  if (availableBiometrics
                                      .contains(BiometricType.face)) {
                                    _startBioMetricAuth(
                                        "Use Face ID for biometric. authentication");
                                  } else if (availableBiometrics
                                      .contains(BiometricType.fingerprint)) {
                                    _startBioMetricAuth(
                                        "Use Fingerprint for biometric. authentication");
                                  }
                                } else {
                                  _startBioMetricAuth(
                                      "Use Fingerprint for biometric. authentication");
                                }
                              }),
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

  void _startBioMetricAuth(String message) async {
    try {
      bool didAuthenticate = await _auth.authenticate(
          localizedReason: message,
          options: const AuthenticationOptions(useErrorDialogs: false));
      if (didAuthenticate) {
        await PreferenceUtil.save('biometric_user', widget.savedUser);
        setState(() {
          _isBiometricActivated = true;
        });
      }
    } on PlatformException catch (e) {}
  }
}
