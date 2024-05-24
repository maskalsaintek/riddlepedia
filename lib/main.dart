import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'modul/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://notwjmvrcasrcsakvlrz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vdHdqbXZyY2FzcmNzYWt2bHJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY0OTI4NjgsImV4cCI6MjAzMjA2ODg2OH0.WroqS1vfDaPSD37SkWVsU3rce4fwPHBKcfn5FCkMjt0',
  );
  await Future.delayed(const Duration(seconds: 2));
  runApp(const MaterialApp(title: "Riddlepedia", home: MainScreen()));
}
