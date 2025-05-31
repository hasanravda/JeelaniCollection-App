// import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:product_repository/product_repository.dart';

// ignore: camel_case_types
class product_price extends StatelessWidget {
  final Product product;
  final bool isDetail;
  const product_price({
    super.key,
    required this.product,
    required this.isDetail,
  });

  @override
  Widget build(BuildContext context) {
    double discountedPrice =
        product.price - (product.price * (product.discount / 100));

    return Row(
      children: [
        Text(
          '₹${discountedPrice.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: isDetail ? 17 : 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 8,
        ),
        product.discount != 0
            ? RichText(
                text: TextSpan(
                    text: 'MRP ',
                    style: TextStyle(
                        color: Colors.black, fontSize: isDetail ? 15 : 13),
                    children: [
                      TextSpan(
                        text: '₹${product.price}',
                        style: TextStyle(
                            fontSize: isDetail ? 15 : 13,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.black),
                      )
                    ]),
              )
            : const SizedBox()
      ],
    );
  }
}
