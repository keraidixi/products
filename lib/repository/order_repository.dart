import 'package:hive/hive.dart';
import '../models/order_model.dart';

class OrderRepository {
  final Box _ordersBox;

  OrderRepository(this._ordersBox);

  Future<void> saveOrder(OrderModel order) async {
    await _ordersBox.put(order.id, order.toJson());
  }
}
