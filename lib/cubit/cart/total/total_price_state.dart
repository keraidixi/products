abstract class CartTotalPriceState {}

class CartTotalPriceInitial extends CartTotalPriceState {}

class CartTotalPriceInProgress extends CartTotalPriceState {}

class CartTotalPriceSuccess extends CartTotalPriceState {
  final double totalPrice;
  CartTotalPriceSuccess(this.totalPrice);
}

class CartTotalPriceFailure extends CartTotalPriceState {
  final String errorMessage;
  CartTotalPriceFailure(this.errorMessage);
}
