import '../../../models/cart_item_model.dart';

abstract class CartLoadState {}

class CartLoadInitial extends CartLoadState {}

class CartLoadInProgress extends CartLoadState {}

class CartLoadSuccess extends CartLoadState {
  final List<CartItemModel> items;
  CartLoadSuccess(this.items);
}

class CartLoadFailure extends CartLoadState {
  final String errorMessage;
  CartLoadFailure(this.errorMessage);
}
