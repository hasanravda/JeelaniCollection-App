import 'package:ecommerce/screens/cart/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/models/cart_model.dart';


class CartCard extends StatelessWidget {
  final CartItem cart;

  const CartCard({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    double discountedPrice =cart.product.price - (cart.product.price * (cart.product.discount / 100));
    return Row(
      children: [
        // Product Image
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(cart.product.image),
            ),
          ),
        ),
        const SizedBox(width: 20),

        // Product Details and Quantity Management
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.product.name,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
               // Show selected size
              Text(
                "Size: ${cart.selectedSize}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹ ${discountedPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF7643),
                    ),
                  ),
                  Row(
                    children: [
                      // Decrease Button
                      IconButton(
                        onPressed: () {
                          if (cart.quantity > 1) {
                            context.read<CartBloc>().add(
                                  UpdateCartItem(cart, cart.quantity - 1),
                                );
                          } else {
                            context.read<CartBloc>().add(RemoveFromCartEvent(cart));
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                      ),

                      // Quantity Text
                      Text(
                        "${cart.quantity}",
                        style: const TextStyle(fontSize: 16),
                      ),

                      // Increase Button
                      IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                                UpdateCartItem(cart, cart.quantity + 1),
                              );
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
