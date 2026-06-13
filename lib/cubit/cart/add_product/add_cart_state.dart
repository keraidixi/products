abstract class CartAddProductState {}

class CartAddProductInitial extends CartAddProductState {}

class CartAddProductInProgress extends CartAddProductState {
  final String productId;
  CartAddProductInProgress(this.productId);
}

class CartAddProductSuccess extends CartAddProductState {
  final String message;

  CartAddProductSuccess(this.message);
}

class CartAddProductFailure extends CartAddProductState {
  final String errorMessage;
  CartAddProductFailure(this.errorMessage);
}