import 'package:ecommerce/screens/cart/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';

class BillingSection extends StatelessWidget {
	final CartLoaded state;

  const BillingSection({
    super.key,
		required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Price Summary",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildPriceRow("Bag Total",
              "₹ ${state.bagTotal.toStringAsFixed(0)}"),
          _buildPriceRow("Discount on MRP",
              "-₹ ${state.discountOnMRP.toStringAsFixed(0)}",
              color: Colors.green),
          _buildPriceRow("Sub Total",
              "₹ ${state.subTotal.toStringAsFixed(0)}"),
          _buildPriceRow(
              "Convenience Charges",
              state.convenienceFee == 0
                  ? "Free"
                  : "₹ ${state.convenienceFee.toStringAsFixed(0)}"),
          const Divider(),
          _buildPriceRow("You Pay",
              "₹ ${state.finalTotal.toStringAsFixed(0)}",
              isBold: true),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.green.shade50,
            child: Text(
                "Yay! You are saving ₹${state.discountOnMRP.toStringAsFixed(0)}.",
                style: const TextStyle(color: Colors.green)),
          )
        ],
      ),
    );
  }
}

Widget _buildPriceRow(String label, String value,
    {bool isBold = false, Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    ),
  );
}