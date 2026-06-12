import 'package:hive/hive.dart';
import '../models/cart_item_model.dart';

class CartRepository {
  final Box _cartBox;

  CartRepository(this._cartBox);

  Future<List<CartItemModel>> loadCart() async {
    final List<CartItemModel> items = [];
    for (var key in _cartBox.keys) {
      final rawData = _cartBox.get(key);
      if (rawData != null) {
        final Map<String, dynamic> jsonMap =
            Map<String, dynamic>.from(rawData as Map);
        items.add(CartItemModel.fromJson(jsonMap));
      }
    }
    return items;
  }

  Future<void> saveItem(String productId, CartItemModel item) async {
    await _cartBox.put(productId, item.toJson());
  }

  Future<void> deleteItem(String productId) async {
    await _cartBox.delete(productId);
  }

  Future<void> clearCart() async {
    await _cartBox.clear();
  }
}
