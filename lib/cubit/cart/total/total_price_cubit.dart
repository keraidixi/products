import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/cart_item_model.dart';
import '../load/load_cart_cubit.dart';
import '../load/load_cart_state.dart';
import 'total_price_state.dart';

class CartTotalPriceCubit extends Cubit<CartTotalPriceState> {
  final CartLoadCubit _cartLoadCubit;
  StreamSubscription? _subscription;

  CartTotalPriceCubit(this._cartLoadCubit) : super(CartTotalPriceInitial()) {
    _subscription = _cartLoadCubit.stream.listen((state) {
      if (state is CartLoadSuccess) {
        _updatePrice(state.items);
      } else if (state is CartLoadInProgress) {
        emit(CartTotalPriceInProgress());
      } else if (state is CartLoadFailure) {
        emit(CartTotalPriceFailure(state.errorMessage));
      }
    });

    final currentState = _cartLoadCubit.state;
    if (currentState is CartLoadSuccess) {
      _updatePrice(currentState.items);
    }
  }

  void _updatePrice(List<CartItemModel> items) {
    emit(CartTotalPriceInProgress());
    try {
      final total = items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
      emit(CartTotalPriceSuccess(total));
    } catch (e) {
      emit(CartTotalPriceFailure('Failed to calculate total price: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
