
import 'package:ecommerce/screens/order/my_orders.dart';
import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Successful")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 50), // Add some space at the top
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.maps_home_work_rounded, color: Colors.green, size: 50),
              SizedBox(width: 10),
              Text("Order Placed Successfully", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 100),
                const SizedBox(height: 16),
                const Text("Your order has been placed successfully!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
          
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyOrdersScreen()));

                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Go to My Orders"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
