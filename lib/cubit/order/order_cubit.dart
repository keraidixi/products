import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/cart_item_model.dart';
import '../../models/order_model.dart';
import '../cart/cart_cubit.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final Box _ordersBox;
  final CartCubit _cartCubit;

  OrderCubit(this._ordersBox, this._cartCubit) : super(OrderInitial());

  void loadOrders(String userId) {
    emit(OrderInProgress());

    try {
      final List<OrderModel> orders = [];

      final keys = _ordersBox.keys.toList();

      for (var key in keys) {
        final rawData = _ordersBox.get(key);

        if (rawData != null) {
          final order = OrderModel.fromJson(Map<String, dynamic>.from(rawData));

          if (order.userId == userId) {
            orders.add(order);
          }
        }
      }

      orders.sort((a, b) => b.orderDateTime.compareTo(a.orderDateTime));

      emit(OrderSuccess(orders));
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  void placeOrder(
      List<CartItemModel> items,
      double totalAmount,
      String email,
      ) async {
    final currentState = state;
    List<OrderModel> currentOrders = [];
    if (currentState is OrderSuccess) {
      currentOrders = List.from(currentState.orders);
    }

    emit(OrderInProgress());
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
      final newOrder = OrderModel(
        id: orderId,
        userId: email,
        items: items,
        totalAmount: totalAmount,
        orderDateTime: DateTime.now(),
      );

      await _ordersBox.put(orderId, newOrder.toJson());

      await _cartCubit.clearCart();

      currentOrders.insert(0, newOrder);
      emit(OrderSuccess(currentOrders));
    } catch (e) {
      emit(OrderFailure('Failed to place order: ${e.toString()}'));
    }
  }
}
