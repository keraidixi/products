import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/cubit/cart/cart_cubit.dart';
import '../../../models/cart_item_model.dart';
import '../../../models/product_model.dart';
import '../../../repository/cart_repository.dart';
import 'add_cart_state.dart';

class CartAddProductCubit extends Cubit<CartAddProductState> {
  final CartRepository _repository;
  final CartCubit _cartCubit;

  CartAddProductCubit(this._repository, this._cartCubit)
      : super(CartAddProductInitial());


  void addProduct(ProductModel product) async {
    addProductWithQuantity(product, 1);
  }

  void addProductWithQuantity(ProductModel product, int quantity) async {
    if (quantity <= 0) return;

    emit(CartAddProductInProgress(product.id));
    await Future.delayed(const Duration(seconds: 1));
    try {
      final currentItems = await _repository.loadCart();
      final existingIndex = currentItems.indexWhere(
            (item) => item.product.id == product.id,
      );

      if (existingIndex != -1) {
        final existingItem = currentItems[existingIndex];
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
        await _repository.saveItem(product.id, updatedItem);
      } else {
        final newItem = CartItemModel(product: product, quantity: quantity);
        await _repository.saveItem(product.id, newItem);
      }

      emit(CartAddProductSuccess('${product.name} added to cart'));

      _cartCubit.loadCart();
    } catch (e) {
      emit(CartAddProductFailure('Failed to add product: ${e.toString()}'));
    }
  }
}
