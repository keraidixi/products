import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cubit/cart/add_product/add_cart_cubit.dart';
import '../../cubit/cart/add_product/add_cart_state.dart';
import '../../cubit/product/product_cubit.dart';
import '../../cubit/product/product_state.dart';
import 'widgets/cart_icon_badge.dart';
import 'widgets/home_drawer.dart';
import 'widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartAddProductCubit, CartAddProductState>(
      listener: (context, state) {
        if (state is CartAddProductSuccess) {
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 1),
            ),
          );
        }

        if (state is CartAddProductFailure) {
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Product',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              fontSize: 29,
            ),
          ),
          actions: const [CartIconBadge(), SizedBox(width: 8)],
        ),
        drawer: const HomeDrawer(),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductInProgress) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFF818CF8)),
                ),
              );
            }

            if (state is ProductFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProductCubit>().loadProducts(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductSuccess) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(product: state.products[index]);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}