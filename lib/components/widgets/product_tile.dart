// import 'package:cached_network_image/cached_network_image.dart';
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
        // if(product!.pId == null) {
        //   // Handle case where product ID is null
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Product ID is not available')),
        //   );
        //   return; 
        // } 
        // context.go('/product/${product!.pId}', extra: product!);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // CachedNetworkImage(
            //   imageUrl: product!.image,
            //   errorWidget: (context, url, error) => Container(
            //     color: Colors.grey[200],
            //     height: 230,
            //     // child: const Center(
            //     //   child: Icon(
            //     //     Icons.broken_image,
            //     //     color: Colors.grey,
            //     //     size: 50,
            //     //   ),
            //     // ),
            //   ),
            // ),

            // Using Image.network with error and loading handling
            Image.network(
              product!.image,
              errorBuilder: (context, error, stackTrace) {
                // Handling case where image fails to load
                return Container(
                  color: Colors.grey[200], // Background color on failure
                  height: 230, // Height of the image container
                  // child: const Center(
                  //   child: Icon(
                  //     Icons.hide_image,
                  //     color: Colors.grey,
                  //     size: 50,
                  //   ),
                  // ),
                );
              },
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