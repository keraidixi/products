abstract class CartQuantityState {}

class CartQuantityInitial extends CartQuantityState {}

class CartQuantityInProgress extends CartQuantityState {}

class CartQuantitySuccess extends CartQuantityState {}

class CartQuantityFailure extends CartQuantityState {
  final String errorMessage;
  CartQuantityFailure(this.errorMessage);
}
