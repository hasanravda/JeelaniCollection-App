import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screens/login/screens/login_bottomsheet.dart';
import 'package:ecommerce/screens/order/my_orders_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {

  @override
  void initState() {
    super.initState();
    _fetchUserOrders();
  }

  Future<List<Map<String, dynamic>>> _fetchUserOrders() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .get();
    log("Fetched ${querySnapshot.docs.length} orders for user $userId");
    // ignore: unnecessary_null_comparison
    if (querySnapshot.docs.any((doc) => doc.data() == null)) {
      log("Warning: Some documents have null data.");
    }
    return querySnapshot.docs
        .map((doc) => doc.data())
        .whereType<Map<String, dynamic>>() // filters out nulls
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          // Delay the bottom sheet to avoid build errors
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              builder: (context) => const LoginBottomSheet(),
            );
          });

          return const Scaffold(
            body: Center(child: Text("Please login to view your orders")),
          );
        }

        return MyOrdersContent(userId: user.uid);
      },
    );
  }
}
