// import 'package:ecommerce/models/cart_model.dart';

// class CartRepository {
//   final List<CartItem> _cart = [];

//   Future<List<CartItem>> fetchCartItems() async {
//     await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
//     return _cart;
//   }

//   Future<void> addCartItem(CartItem item) async {
//     await Future.delayed(const Duration(milliseconds: 100)); // Simulate delay
//     _cart.add(item);
//   }

//   Future<void> removeCartItem(CartItem item) async {
//     await Future.delayed(const Duration(milliseconds: 100)); // Simulate network delay
//     _cart.remove(item);
//   }
// }
import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/models/cart_model.dart';

class CartRepository {
  static const _cartKey = 'cart_items';

  // Fetch cart items from SharedPreferences
  Future<List<CartItem>> fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey);
    if (cartJson != null) {
      try {
        final List<dynamic> decoded = json.decode(cartJson);
        final items = decoded.map((item) => CartItem.fromJson(item)).toList();
        log("Loaded ${items.length} items from SharedPreferences");
        return items;
      } catch (e) {
        log("Error decoding cart JSON: $e");
      }
    }
    return [];
  }

  // Add a new item and save
  Future<void> addCartItem(CartItem item) async {
    final cartItems = await fetchCartItems();

    // Check if item already exists, update quantity instead
    final index = cartItems.indexWhere((i) => i.product.pId == item.product.pId && i.selectedSize == item.selectedSize );
    if (index != -1) {
      final existing = cartItems[index];
      cartItems[index] = CartItem(product: existing.product, quantity: existing.quantity + item.quantity, selectedSize: existing.selectedSize);
    } else {
      cartItems.add(item);
    }

    await _saveCart(cartItems);
    log("Saved cart with ${cartItems.length} items");
  }

  Future<void> saveCart(List<CartItem> items) async {
  await _saveCart(items);
}


  // Remove an item
  Future<void> removeCartItem(CartItem item) async {
    final cartItems = await fetchCartItems();
    cartItems.removeWhere((i) => i.product.pId == item.product.pId);
    await _saveCart(cartItems);
    log("Item removed. Cart now has ${cartItems.length} items");
  }

  // Save the cart to SharedPreferences
  Future<void> _saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => item.toJson()).toList();
    await prefs.setString(_cartKey, json.encode(jsonList));
  }

  // Clear the cart
  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
    log("Cart cleared");
  }
}
