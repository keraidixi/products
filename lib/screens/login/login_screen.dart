import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/cubit/auth/login/login_state.dart';

import '../../cubit/auth/auth_cubit.dart';
import '../../cubit/auth/login/login_cubit.dart';
import '../../repository/auth_repository.dart';
import '../../repository/cart_repository.dart';
import '../home/home_screen.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(
        context.read<AuthRepository>(),
        context.read<CartRepository>(),
      ),
      child: Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.read<AuthCubit>().checkLogin();
        
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            }
        
            if (state is LoginFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is LoginInProgress) {
              return const Center(child: CircularProgressIndicator());
            }
        
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Login', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 50),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  TextField(
                    controller: passController,
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                  const SizedBox(height: 30),
        
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(300, 50),
                      backgroundColor: Color(0xFF6366F1),
                    ),
                    onPressed: () {
                      context.read<LoginCubit>().login(
                        emailController.text.trim(),
                        passController.text.trim(),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SignupScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      ),
    );
  }
}
