import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final DateTime orderDateTime;


  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDateTime,
    required this.userId,

  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderDateTime': orderDateTime.toIso8601String(),

    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['userId'] ?? '',
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderDateTime: DateTime.parse(json['orderDateTime'] as String),

    );
  }
}
