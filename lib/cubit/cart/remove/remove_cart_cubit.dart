import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/cubit/cart/cart_cubit.dart';
import 'remove_cart_state.dart';
import '../../../models/product_model.dart';
import '../../../repository/cart_repository.dart';

class CartRemoveCubit extends Cubit<CartRemoveState> {
  final CartRepository _repository;
  final CartCubit _cartCubit;

  CartRemoveCubit(this._repository, this._cartCubit)
      : super(CartRemoveInitial());

  void removeProduct(ProductModel product) async {
    emit(CartRemoveInProgress(product.id));
    await Future.delayed(Duration(seconds: 2));
    try {
      await _repository.deleteItem(product.id);

      emit(CartRemoveSuccess('${product.name} removed from cart'));

      _cartCubit.loadCart();
    } catch (e) {
      emit(CartRemoveFailure('Failed to remove product: ${e.toString()}'));
    }
  }
}
