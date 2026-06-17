import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:product/cubit/cart/cart_state.dart';

import '../../cubit/auth/auth_cubit.dart';
import '../../cubit/auth/auth_state.dart';
import '../../cubit/cart/cart_cubit.dart';
import '../../cubit/cart/quantity_update/quantity_cart_cubit.dart';
import '../../cubit/cart/remove/remove_cart_cubit.dart';
import '../../cubit/order/order_cubit.dart';

import '../../models/cart_item_model.dart';
import '../../repository/cart_repository.dart';
import 'widgets/cart_empty_view.dart';
import 'widgets/cart_item_tile.dart';
import 'widgets/cart_summary.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _placeOrder(
      BuildContext context,
      List<CartItemModel> items,
      double totalPrice,
      ) {
    if (items.isEmpty) return;

    final authState = context.read<AuthCubit>().state;

    if (authState is AuthSuccess) {
      context.read<OrderCubit>().placeOrder(
        items,
        totalPrice,
        authState.email,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final cartCubit = context.read<CartCubit>();
    final repository = context.read<CartRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<CartQuantityCubit>(
          create: (_) =>
              CartQuantityCubit(repository, cartCubit),
        ),
        BlocProvider<CartRemoveCubit>(
          create: (_) =>
              CartRemoveCubit(repository, cartCubit),
        ),
        BlocProvider<OrderCubit>(
          create: (context) =>
              OrderCubit(Hive.box('orders_box'), context.read<CartCubit>()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Cart',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartInProgress) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CartSuccess) {
                if (state.items.isEmpty) {
                  return const CartEmptyView();
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: state.items.length,
                        separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return CartItemTile(item: state.items[index]);
                        },
                      ),
                    ),
                    CartSummary(
                      totalQty: state.items.fold(0, (s, i) => s + i.quantity),
                      onPlaceOrder: (totalPrice) =>
                          _placeOrder(context, state.items, totalPrice),
                    ),
                  ],
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