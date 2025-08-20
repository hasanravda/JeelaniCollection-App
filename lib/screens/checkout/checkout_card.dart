
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screens/cart/bloc/cart_bloc.dart';
import 'package:ecommerce/screens/login/screens/login_bottomsheet.dart';
import 'package:ecommerce/screens/login/screens/profile_update_page.dart';
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
                onPressed: () async {
                  // Handle if cart is empty
                  final cartState = context.read<CartBloc>().state;
                  if (cartState is CartLoaded && cartState.cartItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Your cart is empty!")),
                    );
                    return;
                  }

                  // 2️⃣  Decide next step based on auth & profile
                  await _handleCheckout(context);
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

Future<void> _handleCheckout(BuildContext context) async {
  final userState = context.read<UserBloc>().state;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  // 🔴 Not logged in at all → show login sheet
  if (firebaseUser == null || userState is UserUnauthenticated) {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => const LoginBottomSheet(),
    );
    return;
  }

  // 🔍 Check Firestore profile
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(firebaseUser.uid)
      .get();

  final hasProfile = doc.exists &&
      (doc.data()?['name'] ?? '').toString().isNotEmpty &&
      (doc.data()?['address'] ?? '').toString().isNotEmpty &&
      (doc.data()?['city'] ?? '').toString().isNotEmpty &&
      (doc.data()?['pincode'] ?? '').toString().isNotEmpty;

  if (!hasProfile) {
    // 🚧 Take user to profile page and wait
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileUpdatePage(
          phoneNumber: firebaseUser.phoneNumber ?? '',
          uid: firebaseUser.uid,
        ),
      ),
    );

    // 🔄 Re‑check profile once they return
    final refreshed = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!(refreshed.exists &&
        (refreshed.data()?['name'] ?? '').toString().isNotEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Profile not completed. Please try again.")),
      );
      return;
    }
  }

  // ✅ All good → go to payment
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Proceeding to Checkout")),
  );
  if (context.mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PaymentScreen()),
    );
  }
}


// //
//                   final userState = context.read<UserBloc>().state;
//                   final user = FirebaseAuth.instance.currentUser;

//                   if (user != null && userState is UserAuthenticated) {
//                     final docSnapshot = await FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(user.uid)
//                         .get();
//                     if (docSnapshot.exists) {
//                       // Proceed to checkout
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Proceeding to Checkout")),
//                       );
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const PaymentScreen(),
//                         ),
//                       );

//                       log("User exists: ${user.email}");
//                     } else {
//                       // ⛳️ Navigate to profile update page (important)
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProfileUpdatePage(
//                             phoneNumber: user.phoneNumber ?? " ",
//                             uid: user.uid,
//                           ),
//                         ),
//                       );
//                       // 🔁 After returning from Profile page, re-check the user doc
//                       final newSnapshot = await FirebaseFirestore.instance
//                           .collection('users')
//                           .doc(user.uid)
//                           .get();

//                       if (newSnapshot.exists) {
//                         // ✅ Now go to checkout
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const PaymentScreen(),
//                           ),
//                         );
//                       } else {
//                         // ❌ Still not saved
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text(
//                                   "Profile not completed. Please try again.")),
//                         );
//                       }

//                       log("User profile created? ${newSnapshot.exists}");
//                     }
//                   } else if (userState is UserUnauthenticated) {
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       isDismissible:
//                           false, // prevents closing when tapped outside
//                       enableDrag: false, // prevents swiping down to close
//                       shape: const RoundedRectangleBorder(
//                         borderRadius:
//                             BorderRadius.vertical(top: Radius.circular(25.0)),
//                       ),
//                       builder: (context) => const LoginBottomSheet(),
//                     );
//                   }
//                 },