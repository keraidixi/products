import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../cubit/cart/cart_cubit.dart';
import '../../cubit/order/order_cubit.dart';
import '../../cubit/order/order_state.dart';
import 'widgets/order_card.dart';
import 'widgets/order_empty_view.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    return BlocProvider<OrderCubit>(
      create: (context) => OrderCubit(
        Hive.box('orders_box'),
        context.read<CartCubit>(),
      )..loadOrders(email),
      child: Scaffold(
        appBar: AppBar(title: const Text("My Orders")),
        body: SafeArea(
          top: false,
          child: BlocConsumer<OrderCubit, OrderState>(
            listener: (context, state) {
              if (state is OrderFailure) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
                    ),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is OrderInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(0xFF818CF8)),
                  ),
                );
              }

              if (state is OrderSuccess) {
                final orders = state.orders;

                if (orders.isEmpty) {
                  return const OrderEmptyView();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return OrderCard(order: orders[index]);
                  },
                );
              }

              if (state is OrderFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          state.errorMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final email = FirebaseAuth.instance.currentUser?.email;

                          if (email != null) {
                            context.read<OrderCubit>().loadOrders(email);
                          }
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}