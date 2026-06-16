import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/cart/remove/remove_cart_cubit.dart';
import '../../../cubit/cart/remove/remove_cart_state.dart';

import '../../../cubit/cart/quantity_update/quantity_cart_cubit.dart';
import '../../../cubit/cart/quantity_update/quantity_cart_state.dart';

import '../../../models/cart_item_model.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item.product;

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
      builder: (context, removeState) {
        final isRemoving =
            removeState is CartRemoveInProgress &&
                removeState.productId == product.id;

        return BlocBuilder<CartQuantityCubit, CartQuantityState>(
          builder: (context, qtyState) {
            final isLoading = qtyState is CartQuantityInProgress;

            return ListTile(
              tileColor: const Color(0xFF1E293B),
              contentPadding: const EdgeInsets.all(10),

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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              subtitle: Text(
                "\$${(product.price * item.quantity).toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.greenAccent),
              ),

              trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: isLoading
                        ? null
                        : () {
                      context.read<CartQuantityCubit>()
                          .updateQuantity(product, item.quantity - 1);
                    },
                  ),

                  Text("${item.quantity}"),

                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: isLoading
                        ? null
                        : () {
                      context.read<CartQuantityCubit>()
                          .updateQuantity(product, item.quantity + 1);
                    },
                  ),

                  isRemoving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : IconButton(
                    icon: const Icon(Icons.delete,),
                    onPressed: () {
                      context.read<CartRemoveCubit>().removeProduct(product);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}