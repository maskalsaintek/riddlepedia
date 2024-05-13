import 'package:flutter/material.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
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
            Container(alignment: Alignment.topLeft, child: const Text("Email")),
            const SizedBox(height: 4),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                  return 'Invalid Email Address';
                }
                return null;
              },
              onChanged: (text) {
                setState(() {});
              },
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(width: 1, color: Colors.black38),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(width: 1, color: Colors.black38),
                ),
                filled: true,
                isDense: true,
                contentPadding: const EdgeInsets.all(14),
                hintStyle: TextStyle(color: Colors.grey[400]),
                hintText: "Enter your email",
                fillColor: Colors.transparent,
              ),
            ),
            20.0.height,
            Container(
                alignment: Alignment.topLeft, child: const Text("Password")),
            const SizedBox(height: 4),
            TextFormField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              validator: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                  return 'Invalid Email Address';
                }
                return null;
              },
              onChanged: (text) {
                setState(() {});
              },
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(width: 1, color: Colors.black38),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(width: 1, color: Colors.black38),
                ),
                filled: true,
                isDense: true,
                contentPadding: const EdgeInsets.all(14),
                hintStyle: TextStyle(color: Colors.grey[400]),
                hintText: "Enter your password",
                fillColor: Colors.transparent,
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
                  width: ((MediaQuery.of(context).size.width - 70) / 2) - 7,
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
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      )
                      ),
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
                  onPressed: () {},
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
