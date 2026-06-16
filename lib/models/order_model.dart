import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String email;
  final List<CartItemModel> items;
  final double totalAmount;
  final DateTime orderDateTime;


  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDateTime,
    required this.email,

  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderDateTime': orderDateTime.toIso8601String(),

    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      email: json['email'] ?? '',
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderDateTime: DateTime.parse(json['orderDateTime'] as String),

    );
  }
}
