import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item_model.dart';
import '../../repository/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartRepository get repository => _repository;

  CartCubit(this._repository) : super(CartInitial()){
    loadCart();
  }

  Future<void> loadCart() async {
    emit(CartInProgress());

    try {
      final items = await _repository.loadCart();

      final totalPrice = _calculateTotal(items);

      emit(CartSuccess(items: items, totalPrice: totalPrice));
    } catch (e) {
      emit(CartFailure('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> clearCart() async {
    emit(CartInProgress());

    try {
      await _repository.clearCart();

      emit(CartSuccess(items: [], totalPrice: 0));
    } catch (e) {
      emit(CartFailure('Failed to clear cart: ${e.toString()}'));
    }
  }

  double _calculateTotal(List<CartItemModel> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }
}
