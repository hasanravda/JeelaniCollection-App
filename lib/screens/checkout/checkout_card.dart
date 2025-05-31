import 'package:ecommerce/screens/cart/bloc/cart_bloc.dart';
import 'package:ecommerce/screens/login/screens/login_bottomsheet.dart';
// import 'package:ecommerce/screens/login/screens/login_bottomsheet.dart';
import 'package:ecommerce/screens/payment/review_order.dart';
import 'package:ecommerce/user/bloc/user_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const SizedBox();
        } else if (state is CartLoaded && state.cartItems.isEmpty) {
          return const SizedBox();
        }
        return const CheckoutCardContent();
      },
    );
  }
}

class CheckoutCardContent extends StatelessWidget {
  const CheckoutCardContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartLoaded) {
                      // final totalPrice = state.cartItems.fold(
                      //   0.0,
                      //   (previousValue, element) => element.product.discount ==
                      //           0
                      //       ? previousValue +
                      //           (element.product.price * element.quantity)
                      //       : previousValue +
                      //           ((element.product.price -
                      //                   (element.product.price *
                      //                       (element.product.discount / 100))) *
                      //               element.quantity),
                      // );
                      final totalPrice = state.finalTotal;
                      return Text(
                        "Rs. ${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF7643),
                        ),
                      );
                    }
                    return const Text("Rs. 0.00",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF7643),
                        ));
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xFFFF7643),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  // Handle if cart is empty
                  final cartState = context.read<CartBloc>().state;
                  if (cartState is CartLoaded && cartState.cartItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Your cart is empty!")),
                    );
                    return;
                  }

                  final userState = context.read<UserBloc>().state;
                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null && userState is UserAuthenticated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Proceeding to Checkout")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentScreen(),
                      ),
                    );
                  } else if (userState is UserUnauthenticated) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0)),
                      ),
                      builder: (context) => const LoginBottomSheet(),
                    );
                  }
                },
                child: const Text(
                  "Check Out",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
