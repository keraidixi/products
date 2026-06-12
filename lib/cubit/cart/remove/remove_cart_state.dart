abstract class CartRemoveState {}

class CartRemoveInitial extends CartRemoveState {}

class CartRemoveInProgress extends CartRemoveState {}

class CartRemoveSuccess extends CartRemoveState {
  final String message;

  CartRemoveSuccess(this.message);
}
class CartRemoveFailure extends CartRemoveState {
  final String errorMessage;
  CartRemoveFailure(this.errorMessage);
}
