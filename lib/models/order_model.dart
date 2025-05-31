import 'package:ecommerce/models/cart_model.dart';

class OrderModel {
  final String? orderId;
  final String userId;
  final String orderStatus;
  final int totalAmount;
  final DateTime orderDate;
  final String address; // or a separate AddressModel
  final List<CartItem> items;
  final String? paymentId;
  final String? paymentMethod;
  final bool isCancelled;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.orderStatus,
    required this.totalAmount,
    required this.orderDate,
    required this.address,
    required this.items,
    this.paymentId,
    this.paymentMethod,
    this.isCancelled = false,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      orderStatus: json['orderStatus'],
      totalAmount: json['totalAmount'],
      orderDate: DateTime.parse(json['orderDate']),
      address: json['address'],
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      paymentId: json['paymentId'],
      paymentMethod: json['paymentMethod'],
      isCancelled: json['isCancelled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'orderStatus': orderStatus,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'address': address,
      'items': items.map((item) => item.toJson()).toList(),
      'paymentId': paymentId,
      'paymentMethod': paymentMethod,
      'isCancelled': isCancelled,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'orderStatus': orderStatus,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'address': address,
      'items': items.map((item) => item.toMap()).toList(),
      'paymentId': paymentId,
      'paymentMethod': paymentMethod,
      'isCancelled': isCancelled,
    };
  }
}
