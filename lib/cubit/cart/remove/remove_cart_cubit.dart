import 'package:flutter_bloc/flutter_bloc.dart';
import 'remove_cart_state.dart';
import '../../../models/product_model.dart';
import '../../../repository/cart_repository.dart';
import '../load/load_cart_cubit.dart';

class CartRemoveCubit extends Cubit<CartRemoveState> {
  final CartRepository _repository;
  final CartLoadCubit _cartLoadCubit;

  CartRemoveCubit(this._repository, this._cartLoadCubit)
    : super(CartRemoveInitial());

  void removeProduct(ProductModel product) async {
    emit(CartRemoveInProgress());
    await Future.delayed(Duration(seconds: 2));
    try {
      await _repository.deleteItem(product.id);

      emit(CartRemoveSuccess('${product.name} removed from cart'));

      _cartLoadCubit.loadCart();
    } catch (e) {
      emit(CartRemoveFailure('Failed to remove product: ${e.toString()}'));
    }
  }
}
