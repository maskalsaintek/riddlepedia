import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:logger/web.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/modul/setting/bloc/setting_bloc.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/modul/webview/webview_screen.dart';
import 'package:riddlepedia/util/preference_util.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:riddlepedia/widget/setting_menu_widget.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riddlepedia/util/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  final RpUser? savedUser;
  final RpUser? savedBiometricUser;
  final String? savedLocale;

  const SettingScreen(
      {super.key, this.savedUser, this.savedBiometricUser, this.savedLocale});

  @override
  State<SettingScreen> createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  var logger = Logger();
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isBiometricActivated = false;
  String _savedLocale = 'en';

  @override
  void initState() {
    super.initState();
    _isBiometricActivated = widget.savedBiometricUser != null;
    _savedLocale = widget.savedLocale ?? 'en';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: RpAppBar(
                title: AppLocalizations.instance.translate('setting_title'),
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
                            title: AppLocalizations.instance.translate('choose_language'),
                            subTitle: _savedLocale == 'en' 
                            ? AppLocalizations.instance.translate('english') 
                            : AppLocalizations.instance.translate('indonesia'),
                            onPressed: () {
                              _showChooseLanguageActionSheet(context);
                            }),
                        if (widget.savedUser != null)
                          SettingMenu(
                              icon: Icons.fingerprint_outlined,
                              title: AppLocalizations.instance
                                  .translate('biometric_login'),
                              subTitle: _isBiometricActivated
                                  ? AppLocalizations.instance
                                      .translate('biometric_auth_activated')
                                  : AppLocalizations.instance
                                      .translate('login_with_biometric'),
                              onPressed: () async {
                                if (_isBiometricActivated) {
                                  showPlatformDialog(
                                    context: context,
                                    builder: (context) => BasicDialogAlert(
                                      title: Text(AppLocalizations.instance
                                          .translate('information')),
                                      content: Text(AppLocalizations.instance
                                          .translate(
                                              'biometric_auth_activated')),
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
                                        AppLocalizations.instance
                                            .translate('use_face_id'));
                                  } else if (availableBiometrics
                                      .contains(BiometricType.fingerprint)) {
                                    _startBioMetricAuth(
                                        AppLocalizations.instance
                                            .translate('use_fingerprint'));
                                  }
                                } else {
                                  _startBioMetricAuth(
                                      AppLocalizations.instance
                                          .translate('use_fingerprint'));
                                }
                              }),
                        SettingMenu(
                            icon: Icons.question_answer_outlined,
                            title: "FAQ",
                            subTitle:
                                AppLocalizations.instance.translate('faq'),
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
                            title: AppLocalizations.instance
                                .translate('about_us'),
                            subTitle: AppLocalizations.instance
                                .translate('riddlepedia_version')
                                .replaceAll('{version}', '1.0'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => WebviewScreen(
                                          title: AppLocalizations.instance
                                              .translate('about_us'),
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
        title: Text(AppLocalizations.instance.translate('choose_language')),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              context.read<SettingBloc>().add(LocaleChanged(Locale('en')));
              setState(() {
                AppLocalizations(const Locale('en', '')).load();
                _savedLocale = 'en';
              });
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("savedLocale", "en");
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.instance.translate('english')),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              context.read<SettingBloc>().add(LocaleChanged(Locale('id')));
              setState(() {
                AppLocalizations(const Locale('id', '')).load();
                _savedLocale = 'id';
              });
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("savedLocale", "id");
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.instance.translate('indonesia')),
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
