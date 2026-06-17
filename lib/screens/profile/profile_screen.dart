import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/auth/auth_cubit.dart';
import '../../cubit/auth/auth_state.dart';
import '../login/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF0F172A),
      ),

      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF818CF8)),
              ),
            );
          }

          if (state is AuthSuccess) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  const Center(
                    child: CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Email",
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    state.email,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Address",
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    state.address,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Phone",
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    state.phone,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text("Logout"),
                              content: const Text(
                                "Are you sure you want to logout?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);

                                    context.read<AuthCubit>().logout();

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LoginScreen(),
                                      ),
                                          (route) => false,
                                    );
                                  },
                                  child: const Text("Logout"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.logout,color: Colors.white,),
                      label: const Text("Logout",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("No user logged in"));
        },
      ),
    );
  }
}
