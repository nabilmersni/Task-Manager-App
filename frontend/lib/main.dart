import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/theme/theme.dart';
import 'package:task_app/features/auth/cubits/auth_cubit.dart';
import 'package:task_app/features/auth/pages/login_page.dart';
import 'package:task_app/features/home/pages/home_page.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthCubit(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task App",
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoggedIn) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
