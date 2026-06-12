import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/cart/add_product/add_cart_cubit.dart';
import '../../../models/product_model.dart';

class QuantityControls extends StatefulWidget {
  final ProductModel product;

  const QuantityControls({super.key, required this.product});

  @override
  State<QuantityControls> createState() => _QuantityControlsState();
}

class _QuantityControlsState extends State<QuantityControls> {
  int _qty = 1;

  void _addToCart() {
    context.read<CartAddProductCubit>().addProductWithQuantity(
      widget.product,
      _qty,
    );

    setState(() {
      _qty = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 18),
              onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
            ),
            Text(
              '$_qty',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 18),
              onPressed: () => setState(() => _qty++),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 36,
          child: ElevatedButton.icon(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add_shopping_cart, size: 16),
            label: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
  }
}