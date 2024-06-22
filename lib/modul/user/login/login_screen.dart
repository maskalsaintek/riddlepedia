import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/web.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/modul/user/bloc/user_bloc.dart';
import 'package:riddlepedia/modul/user/register/register_screen.dart';
import 'package:riddlepedia/util/md5_util.dart';
import 'package:riddlepedia/widget/form_input_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  var logger = Logger();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              hint: "Enter your email",
              title: "Email",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                  return 'Invalid Email Address';
                }
                return null;
              },
            ),
            20.0.height,
            FormInput(
              hint: "Enter your password",
              title: "Password",
              controller: _passwordController,
              keyboardType: TextInputType.emailAddress,
              isVisible: _passwordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Invalid Password';
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
                child: const Text('Forgot password?'),
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
                  child: const Text("Log In",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14))),
            ),
            22.0.height,
            const Row(
              children: [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Or Login with",
                        style: TextStyle(color: Colors.black54))),
                Expanded(child: Divider(thickness: 1)),
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
                            status: 'Loading...',
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
                            status: 'Loading...',
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
                child: const Text("Doesn't have an account yet?"),
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
                  child: const Text("Register",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 16))),
            )
          ],
        ),
      ),
    ));
  }
}
