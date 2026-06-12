abstract class CartClearState {}

class CartClearInitial extends CartClearState {}

class CartClearInProgress extends CartClearState {}

class CartClearSuccess extends CartClearState {}

class CartClearFailure extends CartClearState {
  final String errorMessage;
  CartClearFailure(this.errorMessage);
}
