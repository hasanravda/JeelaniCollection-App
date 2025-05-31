import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart'; // Import the Product model

class CartItem extends Equatable {
  final Product product;
  final int quantity;
  final String selectedSize;

  const CartItem({required this.product, required this.quantity,required this.selectedSize});

  @override
  List<Object?> get props => [product, quantity, selectedSize];

  // Convert a CartItem to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'selectedSize': selectedSize,
    };
  }

  // Convert a Map to a CartItem (for JSON decoding)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      selectedSize: json['selectedSize'],
    );
  }

  // Convert a CartItem to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'selectedSize': selectedSize,
    };
  }
}