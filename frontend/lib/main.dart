import 'package:flutter/material.dart';
import 'package:task_app/core/theme/theme.dart';
import 'package:task_app/features/auth/pages/login_page.dart';
import 'package:task_app/features/auth/pages/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task App",
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
