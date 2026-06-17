import 'package:hive/hive.dart';
import '../models/cart_item_model.dart';

class CartRepository {
  final Box _cartBox;

  String userId;

  CartRepository(this._cartBox, {this.userId=''});

  void updateUser(String id) {
    userId = id;
  }

  String _key(String productId) => '${userId}_$productId';

  Future<List<CartItemModel>> loadCart() async {
    final List<CartItemModel> items = [];

    for (var key in _cartBox.keys) {
      if (!key.toString().startsWith('${userId}_')) continue;

      final raw = _cartBox.get(key);

      if (raw != null) {
        items.add(CartItemModel.fromJson(Map<String, dynamic>.from(raw)));
      }
    }

    return items;
  }

  Future<void> saveItem(String productId, CartItemModel item) async {
    await _cartBox.put(_key(productId), item.toJson());
  }

  Future<void> deleteItem(String productId) async {
    await _cartBox.delete(_key(productId));
  }

  Future<void> clearCart() async {
    final keys = _cartBox.keys.toList();

    for (var key in keys) {
      if (key.toString().startsWith('${userId}_')) {
        await _cartBox.delete(key);
      }
    }
  }
}
