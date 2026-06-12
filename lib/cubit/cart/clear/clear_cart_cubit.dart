import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/cart_repository.dart';
import '../load/load_cart_cubit.dart';
import 'clear_cart_state.dart';

class CartClearCubit extends Cubit<CartClearState> {
  final CartRepository _repository;
  final CartLoadCubit _cartLoadCubit;

  CartClearCubit(this._repository, this._cartLoadCubit)
      : super(CartClearInitial());

  void clearCart() async {
    emit(CartClearInProgress());
    try {
      await _repository.clearCart();
      emit(CartClearSuccess());
      _cartLoadCubit.loadCart();
    } catch (e) {
      emit(CartClearFailure('Failed to clear cart: ${e.toString()}'));
    }
  }
}
