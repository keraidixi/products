import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cubit/cart/load/load_cart_cubit.dart';
import '../../cubit/cart/load/load_cart_state.dart';
import '../../models/cart_item_model.dart';

import '../../cubit/order/order_cubit.dart';
import 'widgets/cart_item_tile.dart';
import 'widgets/cart_summary.dart';
import 'widgets/cart_empty_view.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _placeOrder(
    BuildContext context,
    List<CartItemModel> items,
    double totalPrice,
  ) {
    if (items.isEmpty) return;
    context.read<OrderCubit>().placeOrder(items, totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MY CART',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: BlocBuilder<CartLoadCubit, CartLoadState>(
        builder: (context, state) {
          if (state is CartLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoadSuccess) {
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
    );
  }
}