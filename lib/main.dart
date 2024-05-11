import 'package:flutter/material.dart';
import 'modul/main/main_screen.dart';

void main() async {
  await Future.delayed(Duration(seconds: 2));
  runApp(const MainScreen());
}
