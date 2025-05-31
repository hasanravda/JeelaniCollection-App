import 'package:ecommerce/components/widgets/cart_button.dart';
import 'package:ecommerce/components/widgets/product_price.dart';
import 'package:ecommerce/components/widgets/zoomable_image.dart';
import 'package:ecommerce/screens/cart/bloc/cart_bloc.dart';
import 'package:ecommerce/screens/cart/views/cart_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:product_repository/product_repository.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isAddedToCart = false; // Track cart status
  String? selectedSize;
  List<String> availableSizes = ['XS', 'S', 'M', 'L', 'XL', '2XL'];

  @override
  Widget build(BuildContext context) {
    double discountedPrice = widget.product.price -
        (widget.product.price * (widget.product.discount / 100));
    

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CartButton(
        price: discountedPrice,
        press: () {
          // Check if a size is selected
          if (selectedSize == null) {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) => _showSizeRequiredBottomSheet(context),
            );
            return;
          }
          // Check if the product is already in the cart
          // If it is, show a message and return
          // if (isAddedToCart) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text('${widget.product.name} is already in the cart!'),
          //       duration: const Duration(seconds: 1),
          //     ),
          //   );
          //   return;
          // }
          // Add the product to the cart
          context.read<CartBloc>().add(AddToCartEvent(
                product: widget.product,
                selectedSize: selectedSize!,
              ));
          // Show a snackbar or toast message to indicate the product has been added to the cart
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.product.name} added to cart!'),
              duration: const Duration(seconds: 1),
            ),
          );
          setState(() {
            isAddedToCart = true;
          });
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.product.name),
        actions: [
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(15),
            ),
            icon: const Icon(
              CupertinoIcons.heart,
              size: 26,
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ));
                },
                icon: const Icon(CupertinoIcons.cart, size: 26),
              ),
              if (isAddedToCart)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => _buildMobileLayout(context),
        desktop: (BuildContext context) => _buildWebLayout(context),
        tablet: (BuildContext context) => _buildWebLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    widget.product.sizes.sort((a, b) => a.compareTo(b));
    widget.product.sizes.isNotEmpty
        ? availableSizes = widget.product.sizes
        : availableSizes = ['XS', 'S', 'M', 'L', 'XL', '2XL'];  

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InteractiveViewer(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ZoomableImageScreen(imageUrl: widget.product.image),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.product.image),
                    fit: BoxFit.fill,
                    onError: (exception, stackTrace) {
                      Container(
                        color: Colors.grey[200],
                        // height: 230,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.product.description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                product_price(product: widget.product, isDetail: true),
                const Text(
                  'Inclusive of all taxes',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: .8),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Size",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement size guide navigation
                      },
                      child: const Text("Size Guide",
                          style: TextStyle(color: Colors.pink)),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: availableSizes.map((size) {
                    bool isSelected = selectedSize == size;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSize = size;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade400,
                              ),
                              borderRadius: BorderRadius.circular(22),
                              color: isSelected
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                            child: Text(
                              size,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    // Your existing web layout logic, unchanged
    return const SizedBox(); // Placeholder for demonstration
  }
}

Widget _showSizeRequiredBottomSheet(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const Text(
          'Select a Size',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please select a size before adding this item to your cart.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.pink,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
