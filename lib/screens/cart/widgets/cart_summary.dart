import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/cubit/cart/cart_cubit.dart';
import 'package:product/cubit/cart/cart_state.dart';

import '../../../cubit/order/order_cubit.dart';
import 'order_dialog.dart';

class CartSummary extends StatelessWidget {
  final int totalQty;
  final Function(double) onPlaceOrder;

  const CartSummary({
    super.key,
    required this.totalQty,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        double totalPrice = 0;

        if (state is CartSuccess) {
          totalPrice = state.totalPrice;
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1E293B),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _row('Total Quantity', '$totalQty items'),
              const SizedBox(height: 6),
              const Divider(color: Colors.white12),
              const SizedBox(height: 6),
              _row(
                'Total Price',
                '\$${totalPrice.toStringAsFixed(2)}',
                valueColor: const Color(0xFFFBBF24),
                fontSize: 20,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    onPlaceOrder(totalPrice);

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => BlocProvider.value(
                        value: context.read<OrderCubit>(),
                        child: const OrderLoadingDialog(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _row(
      String label,
      String value, {
        Color valueColor = Colors.white,
        double fontSize = 16,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.outfit(color: Colors.white54)),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}