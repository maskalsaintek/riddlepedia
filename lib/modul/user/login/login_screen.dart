import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/web.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/modul/user/bloc/user_bloc.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/modul/user/register/register_screen.dart';
import 'package:riddlepedia/util/app_localizations.dart';
import 'package:riddlepedia/util/md5_util.dart';
import 'package:riddlepedia/widget/form_input_widget.dart';

class LoginScreen extends StatefulWidget {
  final RpUser? savedBiometricUser;

  const LoginScreen({super.key, this.savedBiometricUser});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  var logger = Logger();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _auth = LocalAuthentication();

  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();

    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            20.0.height,
            FormInput(
              hint: AppLocalizations.instance.translate("enter_your_email"),
              title: "Email",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                  return AppLocalizations.instance
                      .translate("invalid_email_address");
                }
                return null;
              },
            ),
            20.0.height,
            FormInput(
              hint: AppLocalizations.instance.translate("enter_your_password"),
              title: AppLocalizations.instance.translate("password"),
              controller: _passwordController,
              keyboardType: TextInputType.emailAddress,
              isVisible: _passwordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.instance
                      .translate("invalid_password");
                }
                return null;
              },
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(_passwordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 13),
                    foregroundColor: Colors.black87),
                onPressed: () {},
                child: Text(
                    AppLocalizations.instance.translate("forgot_password")),
              ),
            ),
            16.0.height,
            Container(
              height: 44,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: AppColor.secondaryColor,
                  borderRadius: BorderRadius.circular(6)),
              child: TextButton(
                  onPressed: () {
                    context.read<UserBloc>().add(SubmitLoginEvent(
                        email: _emailController.text,
                        password: convertToMd5(_passwordController.text)));
                  },
                  child: Text(AppLocalizations.instance.translate("log_in"),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14))),
            ),
            if (widget.savedBiometricUser != null) 16.0.height,
            if (widget.savedBiometricUser != null)
              Container(
                height: 44,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(6)),
                child: TextButton.icon(
                    icon: const Icon(Icons.fingerprint_outlined,
                        color: Colors.white),
                    onPressed: () async {
                      List<BiometricType> availableBiometrics =
                          await _auth.getAvailableBiometrics();

                      if (Platform.isIOS) {
                        if (availableBiometrics.contains(BiometricType.face)) {
                          _startBioMetricAuth(AppLocalizations.instance
                              .translate("use_face_id_auth"));
                        } else if (availableBiometrics
                            .contains(BiometricType.fingerprint)) {
                          _startBioMetricAuth(AppLocalizations.instance
                              .translate("use_fingerprint_auth"));
                        }
                      } else {
                        _startBioMetricAuth(AppLocalizations.instance
                            .translate("use_fingerprint_auth"));
                      }
                    },
                    label: Text(
                        AppLocalizations.instance
                            .translate("log_with_biometric"),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14))),
              ),
            22.0.height,
            Row(
              children: [
                const Expanded(child: Divider(thickness: 1)),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                        AppLocalizations.instance.translate("or_login_with"),
                        style: const TextStyle(color: Colors.black54))),
                const Expanded(child: Divider(thickness: 1)),
              ],
            ),
            22.0.height,
            Row(
              children: [
                15.0.width,
                Container(
                  height: 44,
                  width: ((MediaQuery.of(context).size.width - 70) / 2) - 7,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black38)),
                  child: TextButton(
                    onPressed: () async {
                      final LoginResult result =
                          await FacebookAuth.instance.login(
                        permissions: ['public_profile', 'email'],
                      );
                      if (result.status == LoginStatus.success) {
                        final AccessToken accessToken = result.accessToken!;
                        logger.d('token fb = ${accessToken}');
                        final userData = await FacebookAuth.i.getUserData(
                          fields: "name,email",
                        );
                        EasyLoading.show(
                            status: AppLocalizations.instance
                                .translate('loading...'),
                            maskType: EasyLoadingMaskType.black);
                        logger.d('userData = ${userData['id']}');
                        context.read<UserBloc>().add(SubmitLoginFacebookEvent(
                            email: userData['email'],
                            name: userData['name'],
                            id: int.parse(userData['id'])));
                      }
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/image/facebook_logo.png',
                            width: 24,
                            height: 24,
                          ),
                          4.0.width, // Use SizedBox for consistent spacing
                          const Text(
                            'Facebook',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                14.0.width,
                Container(
                  height: 44,
                  width: ((MediaQuery.of(context).size.width - 70) / 2) - 7,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black38)),
                  child: TextButton(
                      onPressed: () async {
                        const List<String> scopes = <String>[
                          'email',
                          'https://www.googleapis.com/auth/contacts.readonly',
                        ];

                        GoogleSignIn _googleSignIn = GoogleSignIn(
                          scopes: scopes,
                        );
                        final GoogleSignInAccount? googleUser =
                            await _googleSignIn.signIn();

                        if (googleUser == null) {
                          logger.d('empty google user');
                          return;
                        }

                        EasyLoading.show(
                            status: AppLocalizations.instance
                                .translate("loading..."),
                            maskType: EasyLoadingMaskType.black);
                        context.read<UserBloc>().add(SubmitLoginFacebookEvent(
                            email: googleUser!.email,
                            name: googleUser.displayName!,
                            id: int.parse(googleUser.id.substring(0, 6))));
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/image/google_logo.png',
                              width: 19,
                              height: 19,
                            ),
                            4.0.width,
                            const Text(
                              'Google',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
            20.0.height,
            Align(
              alignment: Alignment.center,
              child: TextButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 13),
                    foregroundColor: Colors.black87),
                onPressed: () {},
                child: Text(AppLocalizations.instance
                    .translate("doesnt_have_account_yet")),
              ),
            ),
            Container(
              height: 44,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black38)),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const RegisterScreen(),
                    ));
                  },
                  child: Text(AppLocalizations.instance.translate("register"),
                      style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 16))),
            )
          ],
        ),
      ),
    ));
  }

  void _startBioMetricAuth(String message) async {
    try {
      bool didAuthenticate = await _auth.authenticate(
          localizedReason: message,
          options: const AuthenticationOptions(useErrorDialogs: false));
      if (didAuthenticate) {
        context.read<UserBloc>().add(SubmiBiometrictLoginEvent());
      }
    } on PlatformException catch (e) {}
  }
}
