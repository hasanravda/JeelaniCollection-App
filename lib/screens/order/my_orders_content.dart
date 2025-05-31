import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class MyOrdersContent extends StatefulWidget {
  final String userId;
  const MyOrdersContent({super.key, required this.userId});

  @override
  State<MyOrdersContent> createState() => _MyOrdersContentState();
}

class _MyOrdersContentState extends State<MyOrdersContent> {
  late Future<List<Map<String, dynamic>>> _userOrdersFuture;

  @override
  void initState() {
    super.initState();
    _userOrdersFuture = _fetchUserOrders();
  }

  Future<List<Map<String, dynamic>>> _fetchUserOrders() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: widget.userId)
        .orderBy('orderDate', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data())
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userOrdersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmer();
          }
          if (snapshot.hasError) {
            print("Error fetching orders: ${snapshot.error}");
            return const Center(child: Text("Something went wrong."));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text("No orders yet! 🛒"));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = List<Map<String, dynamic>>.from(order['items'] ?? []);
              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Order ID: ${order['orderId']}",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(" ${order['orderDate'].toString().split('T')[0]}",
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount: ₹${order['totalAmount']}"),
                          Text("Payment: ${order['paymentMethod']}"),
                        ],
                      ),
                      Text("Status: ${order['orderStatus']}"),
                      const Divider(height: 16),
                      ...items.map((item) {
                        final product = item['product'];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product['image'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.fill,
                            ),
                          ),
                          title: Text(product['name']),
                          subtitle: Text(
                              "Size: ${item['selectedSize']}  |  Qty: ${item['quantity']}"),
                          trailing: Text("₹${product['price']}"),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 3,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 140,
              width: double.infinity,
            ),
          ),
        );
      },
    );
  }
}
