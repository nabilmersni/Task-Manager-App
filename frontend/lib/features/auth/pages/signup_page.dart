import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/cubits/auth_cubit.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignupPage(),
      );
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUp() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUp) {
            Navigator.of(context).pop();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Sign Up.",
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: "Name",
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Name field cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: "Email",
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty ||
                                !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                    .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            hintText: "Password",
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty || value.length < 8) {
                              return 'Password must be atleast 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: signUp,
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: "Sign In",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pop();
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
