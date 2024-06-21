import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/modul/user/register/bloc/register_bloc.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:riddlepedia/widget/form_input_widget.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
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
            body: BlocListener<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  if (state is LoadingIsVisible) {
                    EasyLoading.show(
                        status: 'Registering...',
                        maskType: EasyLoadingMaskType.black);
                  }

                  if (state is LoadingIsNotVisible) {
                    EasyLoading.dismiss();
                  }

                  if (state is RegisterSuccess) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.topSlide,
                      title: 'Congratulation',
                      desc: 'Your registration has been success',
                      btnOkOnPress: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          SystemNavigator.pop();
                        }
                      },
                    ).show();
                  }

                  if (state is RegisterFailed) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.topSlide,
                      title: 'Sorry',
                      desc: 'Your registration Failed',
                      btnOkColor: Colors.red[700],
                      btnOkOnPress: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          SystemNavigator.pop();
                        }

                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          SystemNavigator.pop();
                        }
                      },
                    ).show();
                  }
                },
                child: SingleChildScrollView(
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
                            if (value == null || value.isEmpty) {
                              return 'Invalid Email Address';
                            }

                            if (value.isNotEmpty &&
                                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                              return 'Invalid Email Address';
                            }
                            return null;
                          },
                        ),
                        20.0.height,
                        FormInput(
                          hint: "Enter your full name",
                          title: "Full Name",
                          controller: _fullNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Invalid Full Name';
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
                              return 'Invalid Confirm Password';
                            }

                            if (value.isNotEmpty &&
                                value != _passwordController.text) {
                              return 'Confirm Password doesn\'t match';
                            }

                            return null;
                          },
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                              icon: Icon(_isConfirmPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined)),
                        ),
                        26.0.height,
                        Container(
                          height: 44,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              borderRadius: BorderRadius.circular(6)),
                          child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<RegisterBloc>().add(
                                      SubmitRegisterEvent(
                                          email: _emailController.text,
                                          fullName: _fullNameController.text,
                                          password: _generateMd5(
                                              _passwordController.text)));
                                }
                              },
                              child: const Text("Register",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))),
                        )
                      ],
                    ),
                  ),
                )))));
  }

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
