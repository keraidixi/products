import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/auth/auth_cubit.dart';
import '../../cubit/auth/auth_state.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final addController = TextEditingController();
  final phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pop(context);
          }

          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthInProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                TextField(
                  controller: passController,
                  decoration: const InputDecoration(hintText: "Password"),
                ),
                TextField(
                  controller: addController,
                  decoration: const InputDecoration(hintText: "Address"),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(hintText: "Phone"),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().signup(
                      emailController.text.trim(),
                      passController.text.trim(),
                      addController.text.trim(),
                      phoneController.text.trim(),
                    );
                  },
                  child: const Text("Signup"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}