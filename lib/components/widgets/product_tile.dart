import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/components/widgets/product_price.dart';
import 'package:ecommerce/components/widgets/product_shimmer.dart';
import 'package:ecommerce/screens/detail_page/views/detail_screen.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:product_repository/product_repository.dart';

class ProductTile extends StatelessWidget {
  final Product? product;

  const ProductTile({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (product == null) {
      return buildProductShimmer(screenWidth);
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(product: product!),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Using CachedNetworkImage (no fixed size, no BoxFit to avoid cropping)
            CachedNetworkImage(
              imageUrl: product!.image,
              fadeInDuration: const Duration(milliseconds: 200),
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
              ),
            ),

            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Text(
                product!.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF272727),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Text(
                product!.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF272727),
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: product_price(product: product!, isDetail: false),
            ),
          ],
        ),
      ),
    );
  }
}
