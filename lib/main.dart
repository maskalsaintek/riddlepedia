import 'package:flutter/material.dart';
import 'modul/main/main_screen.dart';

void main() async {
  await Future.delayed(const Duration(seconds: 2));
  runApp(const MaterialApp(title: "Riddlepedia", home: MainScreen()));
}
