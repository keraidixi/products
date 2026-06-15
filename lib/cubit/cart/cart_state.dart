import '../../../models/cart_item_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartInProgress extends CartState {}

class CartSuccess extends CartState {
  final List<CartItemModel> items;
  final double totalPrice;

  CartSuccess({required this.items, required this.totalPrice});
}

class CartFailure extends CartState {
  final String errorMessage;

  CartFailure(this.errorMessage);
}
