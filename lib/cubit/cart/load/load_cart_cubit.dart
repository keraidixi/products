import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/cart_repository.dart';
import 'load_cart_state.dart';

class CartLoadCubit extends Cubit<CartLoadState> {
  final CartRepository _repository;

  CartLoadCubit(this._repository) : super(CartLoadInitial());

  void loadCart() async {
    emit(CartLoadInProgress());
    try {
      final items = await _repository.loadCart();
      emit(CartLoadSuccess(items));
    } catch (e) {
      emit(CartLoadFailure('Failed to load cart: ${e.toString()}'));
    }
  }
}
