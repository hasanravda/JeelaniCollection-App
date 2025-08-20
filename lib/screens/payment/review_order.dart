// ignore_for_file: unused_element

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/components/widgets/billing_section.dart';
import 'package:ecommerce/models/order_model.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/screens/cart/bloc/cart_bloc.dart';
import 'package:ecommerce/screens/cart/views/cart_screen.dart';
import 'package:ecommerce/screens/login/screens/profile_update_page.dart';
import 'package:ecommerce/screens/order/order_success_screen.dart';
import 'package:ecommerce/screens/payment/payment_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:razorpay_web/razorpay_web.dart' as web;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _paymentService.init(
        onWebSuccess: (response) => _handleWebPaymentSuccess(response),
        onWebError: (response) => _handleWebPaymentError(response),
        onWebExternalWallet: (response) => _handleWebExternalWallet(response),
      );
    } else {
      _paymentService.init(
        onMobileSuccess: _handlePaymentSuccess,
        onMobileError: _handlePaymentError,
        onMobileExternalWallet: _handleExternalWallet,
      );
    }
    context.read<CartBloc>().add(LoadCartEvent());
  }

  Future<UserModel?> _fetchUserDetails() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      return UserModel.fromMap(snapshot.data()!);
    }
    return null;
  }

  // Web platform callbacks
  void _handleWebPaymentSuccess(web.PaymentSuccessResponse response) {
    debugPrint('Web SUCCESS: ${response.paymentId}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment successful: ${response.paymentId}')),
    );

    final cartState = context.read<CartBloc>().state;
    if (cartState is CartLoaded) {
      _saveWebOrder(response, cartState);
    }
  }

  void _handleWebPaymentError(web.PaymentFailureResponse response) {
    debugPrint('Web ERROR: ${response.message}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );

    setState(() {
      _isProcessing = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  void _handleWebExternalWallet(web.ExternalWalletResponse response) {
    debugPrint('Web WALLET: ${response.walletName}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet: ${response.walletName}')),
    );

    setState(() {
      _isProcessing = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log('SUCCESS: ${response.paymentId}');

    // Handle successful payment here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment successful: ${response.paymentId}')),
    );

    // Save order to Firestore here
    // You can use the response.paymentId to save the payment details
    // and order details to your Firestore database.
    // For example:
    // Assuming you have a CartBloc that provides the cart items
    final cartState = context.read<CartBloc>().state;
    if (cartState is CartLoaded) {
      // Save the order details
      _saveOrder(response, cartState);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('ERROR: ${response.message}');
    // Handle payment failure here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('WALLET: ${response.walletName}');
    // Handle external wallet payment here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet: ${response.walletName}')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }

  void _startPayment(double amount, String email, String contact) {
    _paymentService.openCheckout(
      amount: amount,
      name: "Jeelani Collection",
      description: "Test Payment",
      contact: contact,
      email: email,
    );
  }

  Future<void> _saveWebOrder(
      web.PaymentSuccessResponse response, CartLoaded cartState) async {
    final cartItems = cartState.cartItems;
    final orderItems = cartItems.map((item) => item).toList();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    String address = "User Address"; // Default address
    if (userSnapshot.exists) {
      final userData = userSnapshot.data();
      address =
          "${userData?['address']}, ${userData?['city']}, ${userData?['state']} - ${userData?['pincode']}";
    }

    final order = OrderModel(
      userId: userId,
      orderId: response.orderId ?? response.paymentId ?? "N/A",
      orderStatus: "Pending",
      totalAmount: cartState.finalTotal
          .toInt(), // Calculate total amount based on order items
      orderDate: DateTime.now(),
      address: address,
      items: orderItems,
      paymentId: response.paymentId,
      paymentMethod: "Razorpay",
      isCancelled: false,
    );
    final docId = response.orderId ??
        response.paymentId ??
        FirebaseFirestore.instance.collection('orders').doc().id;
    // Save the order to Firestore
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docId) // Use orderId as document ID
        .set(order.toMap())
        .then((value) {
      log("Order saved successfully");
      context.read<CartBloc>().add(ClearCartEvent());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
      );
    }).catchError((error) {
      log("Failed to save order: $error");
    });
  }

  void _saveOrder(PaymentSuccessResponse response, CartLoaded cartState) {
    final cartItems = cartState.cartItems;
    final orderItems = cartItems.map((item) => item).toList();

    final order = OrderModel(
      userId: FirebaseAuth.instance.currentUser!.uid,
      orderId: response.orderId ?? response.paymentId ?? "N/A",
      orderStatus: "Pending",
      totalAmount: cartState.finalTotal
          .toInt(), // Calculate total amount based on order items
      orderDate: DateTime.now(),
      address: "User Address", // Replace with actual address
      items: orderItems,
      paymentId: response.paymentId,
      paymentMethod: "Razorpay",
      isCancelled: false,
    );
    final docId = response.orderId ??
        response.paymentId ??
        FirebaseFirestore.instance.collection('orders').doc().id;
    // Save the order to Firestore
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docId) // Use orderId as document ID
        .set(order.toMap())
        .then((value) {
      log("Order saved successfully");
      context.read<CartBloc>().add(ClearCartEvent());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
      );
    }).catchError((error) {
      log("Failed to save order: $error");
    });
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Order"),
        leading: const BackButton(),
      ),
      body: FutureBuilder<UserModel?>(
        future: _fetchUserDetails(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userSnapshot.data;

          if (user == null) {
            return const Center(child: Text("User data not found."));
          }

          return BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CartLoaded) {
                final cartItems = state.cartItems;
                final total = state.finalTotal;
                final savings = state.discountOnMRP;

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Address Section
                    Card(
                      color: Colors.orange[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Deliver to ${user.name}, ${user.pincode}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(
                                "${user.address}, ${user.city}, ${user.state} - ${user.pincode}"),
                            Text("Phone: ${user.phoneNumber}"),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {
                                // TODO: Navigate to address change screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileUpdatePage(
                                      phoneNumber: user.phoneNumber,
                                      uid: user.uid,
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Change or add address"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Order Information
                    const Text("Order Information",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    // Price Details
                    Card(
                      child: ExpansionTile(
                        title: const Text("Price Details"),
                        subtitle: Text(
                            "You are saving ₹${savings.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.green)),
                        trailing: Text("₹$total"),
                        children: [
                          BillingSection(state: state),
                        ],
                      ),
                    ),

                    // Delivery Estimate
                    Card(
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: const Text("Delivery Estimate"),
                        children: cartItems.map((item) {
                          return ListTile(
                            leading: Image.network(item.product.image,
                                width: 50, height: 50),
                            title: Text(item.product.name),
                            subtitle: const Text("Delivery in 2-3 days"),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text("Something went wrong."));
              }
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _isProcessing
              ? null
              : () async {
                  setState(() {
                    _isProcessing = true; // Disable button immediately
                  });
                  // Get the total amount from the cart state
                  final cartState = context.read<CartBloc>().state;
                  final user = FirebaseAuth.instance.currentUser;
                  try {
                    final userSnapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .get();

                    if (userSnapshot.exists) {
                      final userData = userSnapshot.data();
                      final email = userData!['email'];
                      final contact = userData['phoneNumber'];
                      // Start payment with the total amount
                      if (cartState is CartLoaded) {
                        _startPayment(cartState.finalTotal, email, contact);
                      }
                    }
                  } catch (e) {
                    log("Error in starting payment: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Something went wrong. Please try again.")),
                    );
                    setState(() {
                      _isProcessing = false; // Re-enable on error
                    });
                  }
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: const Color(0xFFFF7643),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: _isProcessing
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Proceed to Pay",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
