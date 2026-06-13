import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cubit/cart/add_product/add_cart_cubit.dart';
import '../../cubit/cart/load/load_cart_cubit.dart';
import '../../cubit/product/product_cubit.dart';
import '../../cubit/product/product_state.dart';
import 'widgets/cart_icon_badge.dart';
import 'widgets/home_drawer.dart';
import 'widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartLoadCubit = context.read<CartLoadCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(
          create: (_) => ProductCubit()..loadProducts(),
        ),
        BlocProvider<CartAddProductCubit>(
          create: (_) =>
              CartAddProductCubit(cartLoadCubit.cartRepository, cartLoadCubit),
        ),
      ],
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
        body: SafeArea(
          top: false,
          child: BlocBuilder<ProductCubit, ProductState>(
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
                final screenWidth = MediaQuery.sizeOf(context).width;
                final cardWidth = (screenWidth - 48) / 2;
                final cardHeight = cardWidth / 1.1 + 90;
                final ratio = cardWidth / cardHeight;

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: state.products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: ratio,
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
      ),
    );
  }
}