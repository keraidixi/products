import '../../models/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderInProgress extends OrderState {}

class OrderSuccess extends OrderState {
  final List<OrderModel> orders;
  OrderSuccess(this.orders);
}

class OrderFailure extends OrderState {
  final String errorMessage;
  OrderFailure(this.errorMessage);
}
