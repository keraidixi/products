import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/auth/signup/signup_cubit.dart';
import '../../cubit/auth/signup/signup_state.dart';
import '../../repository/auth_repository.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final addController = TextEditingController();
  final phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupCubit>(
      create: (context) => SignupCubit(context.read<AuthRepository>()),
      child: Scaffold(
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            Navigator.pop(context);
          }

          if (state is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is SignupInProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Signup',style: TextStyle(fontSize: 20),),
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

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    backgroundColor: Color(0xFF6366F1),
                  ),
                  onPressed: () {
                    context.read<SignupCubit>().signup(
                      emailController.text.trim(),
                      passController.text.trim(),
                      addController.text.trim(),
                      phoneController.text.trim(),
                    );
                  },
                  child: const Text("Signup",style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}