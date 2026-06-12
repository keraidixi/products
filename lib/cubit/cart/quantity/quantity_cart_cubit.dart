import 'package:flutter_bloc/flutter_bloc.dart';
import 'quantity_cart_state.dart';
import '../../../models/cart_item_model.dart';
import '../../../models/product_model.dart';
import '../../../repository/cart_repository.dart';
import '../load/load_cart_cubit.dart';

class CartQuantityCubit extends Cubit<CartQuantityState> {
  final CartRepository _repository;
  final CartLoadCubit _cartLoadCubit;

  CartQuantityCubit(this._repository, this._cartLoadCubit)
      : super(CartQuantityInitial());

  void updateQuantity(ProductModel product, int quantity) async {
    emit(CartQuantityInProgress());
    try {
      if (quantity <= 0) {
        await _repository.deleteItem(product.id);
      } else {
        final currentItems = await _repository.loadCart();
        final existingIndex = currentItems.indexWhere((item) => item.product.id == product.id);

        if (existingIndex != -1) {
          final updatedItem = currentItems[existingIndex].copyWith(quantity: quantity);
          await _repository.saveItem(product.id, updatedItem);
        } else {
          final newItem = CartItemModel(product: product, quantity: quantity);
          await _repository.saveItem(product.id, newItem);
        }
      }
      emit(CartQuantitySuccess());
      _cartLoadCubit.loadCart();
    } catch (e) {
      emit(CartQuantityFailure('Failed to update quantity: ${e.toString()}'));
    }
  }
}
