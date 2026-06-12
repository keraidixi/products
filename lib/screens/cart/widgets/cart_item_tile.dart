import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../cubit/cart/remove/remove_cart_cubit.dart';
import '../../../cubit/cart/remove/remove_cart_state.dart';
import '../../../models/cart_item_model.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;

  const CartItemTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CartRemoveCubit, CartRemoveState>(
      listener: (context, state) {
        if (state is CartRemoveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        if (state is CartRemoveFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },

      builder: (context, state) {
        if (state is CartRemoveInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = item.product;

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '\$${(product.price * item.quantity).toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFF34D399),
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete_outline,
                size: 22,
                color: Colors.redAccent,
              ),
              onPressed: () {
                context.read<CartRemoveCubit>().removeProduct(product);
              },
            ),
          ),
        );
      },
    );
  }
}