import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/order/order_cubit.dart';
import '../../../cubit/order/order_state.dart';
import '../../../cubit/cart/clear/clear_cart_cubit.dart';
import 'order_success_dialog.dart';

class OrderLoadingDialog extends StatelessWidget {
  const OrderLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          context.read<CartClearCubit>().clearCart();

          final navigator = Navigator.of(context);
          navigator.pop();

          showDialog(
            context: navigator.context,
            barrierDismissible: false,
            builder: (_) => const OrderSuccessDialog(),
          );
        } else if (state is OrderFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return const Center(
          child: Card(
            color: Color(0xFF1E293B),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      Color(0xFF34D399),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Processing Order...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}