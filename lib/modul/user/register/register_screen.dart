import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:riddlepedia/widget/form_input_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late bool _passwordVisible;
  late bool _isConfirmPasswordVisible;

  @override
  void initState() {
    super.initState();

    _passwordVisible = false;
    _isConfirmPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: RpAppBar(
                title: "Register",
                appBarType: RpAppBarType.modal,
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
                    20.0.height,
                    FormInput(
                      hint: "Enter your password",
                      title: "Confirm Password",
                      controller: _confirmPasswordController,
                      isVisible: _isConfirmPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid Password';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
                          onPressed: () {},
                          child: const Text("Register",
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
                            child: Text("Or Register with",
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
                          width:
                              ((MediaQuery.of(context).size.width - 70) / 2) -
                                  7,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black38)),
                          child: TextButton(
                            onPressed: () {},
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
                          width:
                              ((MediaQuery.of(context).size.width - 70) / 2) -
                                  7,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black38)),
                          child: TextButton(
                              onPressed: () {},
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
                    )
                  ],
                ),
              ),
            ))));
  }
}
