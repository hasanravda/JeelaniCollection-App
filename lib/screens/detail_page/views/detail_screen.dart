// import 'package:ecommerce/components/widgets/cart_button.dart';
// import 'package:ecommerce/components/widgets/product_price.dart';
// import 'package:ecommerce/components/widgets/zoomable_image.dart';
// import 'package:ecommerce/screens/cart/bloc/cart_bloc.dart';
// import 'package:ecommerce/screens/cart/views/cart_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:product_repository/product_repository.dart';

// class DetailScreen extends StatefulWidget {
//   final Product product;
//   const DetailScreen({super.key, required this.product});

//   @override
//   State<DetailScreen> createState() => _DetailScreenState();
// }

// class _DetailScreenState extends State<DetailScreen> {
//   bool isAddedToCart = false; // Track cart status
//   String? selectedSize;
//   List<String> availableSizes = ['XS', 'S', 'M', 'L', 'XL', '2XL'];

//   @override
//   Widget build(BuildContext context) {
//     double discountedPrice = widget.product.price -
//         (widget.product.price * (widget.product.discount / 100));

//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: MediaQuery.of(context).size.width > 600
//           ? null
//           : CartButton(
//               price: discountedPrice,
//               press: () {
//                 // Check if a size is selected
//                 if (selectedSize == null) {
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled:
//                         true, // keep this if you're using full height with keyboard
//                     isDismissible:
//                         false, // prevents closing when tapped outside
//                     enableDrag: false, // prevents swiping down to close
//                     shape: const RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(16)),
//                     ),
//                     builder: (_) => _showSizeRequiredBottomSheet(context),
//                   );
//                   return;
//                 }
//                 // Check if the product is already in the cart
//                 // If it is, show a message and return
//                 // if (isAddedToCart) {
//                 //   ScaffoldMessenger.of(context).showSnackBar(
//                 //     SnackBar(
//                 //       content: Text('${widget.product.name} is already in the cart!'),
//                 //       duration: const Duration(seconds: 1),
//                 //     ),
//                 //   );
//                 //   return;
//                 // }
//                 // Add the product to the cart
//                 context.read<CartBloc>().add(AddToCartEvent(
//                       product: widget.product,
//                       selectedSize: selectedSize!,
//                     ));
//                 // Show a snackbar or toast message to indicate the product has been added to the cart
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('${widget.product.name} added to cart!'),
//                   ),
//                 );
//                 setState(() {
//                   isAddedToCart = true;
//                 });
//               },
//             ),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(widget.product.name),
//         leading: IconButton(
//           icon: const Icon(CupertinoIcons.back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             style: IconButton.styleFrom(
//               padding: const EdgeInsets.all(15),
//             ),
//             icon: const Icon(
//               CupertinoIcons.heart,
//               size: 26,
//             ),
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CartScreen(),
//                       ));
//                 },
//                 icon: const Icon(CupertinoIcons.cart, size: 26),
//               ),
//               if (isAddedToCart)
//                 Positioned(
//                   right: 6,
//                   top: 6,
//                   child: Container(
//                     width: 10,
//                     height: 10,
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//       body: ScreenTypeLayout.builder(
//         mobile: (BuildContext context) => _buildMobileLayout(context),
//         desktop: (BuildContext context) => _buildWebLayout(context),
//         tablet: (BuildContext context) => _buildWebLayout(context),
//       ),
//     );
//   }

//   Widget _buildMobileLayout(BuildContext context) {
//     widget.product.sizes.sort((a, b) => a.compareTo(b));
//     widget.product.sizes.isNotEmpty
//         ? availableSizes = widget.product.sizes
//         : availableSizes = ['XS', 'S', 'M', 'L', 'XL', '2XL'];

//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           InteractiveViewer(
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         ZoomableImageScreen(imageUrl: widget.product.image),
//                   ),
//                 );
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height / 1.6,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(widget.product.image),
//                     fit: BoxFit.fill,
//                     onError: (exception, stackTrace) {
//                       Container(
//                         color: Colors.grey[200],
//                         // height: 230,
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.product.name,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   widget.product.description,
//                   style: const TextStyle(fontSize: 14),
//                 ),
//                 const SizedBox(height: 8),
//                 product_price(product: widget.product, isDetail: true),
//                 const Text(
//                   'Inclusive of all taxes',
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 const SizedBox(height: 10),
//                 const Divider(thickness: .8),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Select Size",
//                       style:
//                           TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         // TODO: Implement size guide navigation
//                       },
//                       child: const Text("Size Guide",
//                           style: TextStyle(color: Colors.pink)),
//                     ),
//                   ],
//                 ),
//                 Wrap(
//                   spacing: 10,
//                   runSpacing: 10,
//                   children: availableSizes.map((size) {
//                     bool isSelected = selectedSize == size;
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedSize = size;
//                         });
//                       },
//                       child: Column(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 15),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: isSelected
//                                     ? Colors.black
//                                     : Colors.grey.shade400,
//                               ),
//                               borderRadius: BorderRadius.circular(22),
//                               color: isSelected
//                                   ? Colors.black
//                                   : Colors.transparent,
//                             ),
//                             child: Text(
//                               size,
//                               style: TextStyle(
//                                 color: isSelected ? Colors.white : Colors.black,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWebLayout(BuildContext context) {
//     widget.product.sizes.sort((a, b) => a.compareTo(b));
//     widget.product.sizes.isNotEmpty
//         ? availableSizes = widget.product.sizes
//         : availableSizes = ['XS', 'S', 'M', 'L', 'XL', '2XL'];

//     return SingleChildScrollView(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Left side - Product Image
//             Expanded(
//               flex: 3,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       spreadRadius: 2,
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   // child: InteractiveViewer(
//                   //   panEnabled: true,
//                   //   boundaryMargin: const EdgeInsets.all(20),
//                   //   minScale: 0.8,
//                   //   maxScale: 3.0,
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ZoomableImageScreen(
//                               imageUrl: widget.product.image),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       height: MediaQuery.of(context).size.height * 0.85,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(widget.product.image),
//                           fit: BoxFit.fill,
//                           onError: (exception, stackTrace) {
//                             Container(
//                               color: Colors.grey[200],
//                               child: const Center(
//                                 child: Icon(
//                                   Icons.image_not_supported,
//                                   size: 50,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.1),
//                             ],
//                           ),
//                         ),
//                         child: Stack(
//                           children: [
//                             Positioned(
//                               top: 16,
//                               right: 16,
//                               child: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.9),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: const Icon(
//                                   Icons.zoom_in,
//                                   size: 20,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   // ),
//                 ),
//               ),
//             ),

//             const SizedBox(width: 40),

//             // Right side - Product Details
//             Expanded(
//               flex: 2,
//               child: Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.08),
//                       spreadRadius: 1,
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Product Name
//                     Text(
//                       widget.product.name,
//                       style: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black87,
//                         height: 1.3,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Product Description
//                     Text(
//                       widget.product.description,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                         height: 1.5,
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Price Section
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[50],
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           product_price(
//                               product: widget.product, isDetail: true),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Inclusive of all taxes',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Size Selection Section
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "Select Size",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 18,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               TextButton.icon(
//                                 onPressed: () {
//                                   // TODO: Implement size guide navigation
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return AlertDialog(
//                                         title: const Text('Size Guide'),
//                                         content: const Text(
//                                           'Size guide information will be displayed here.',
//                                         ),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () =>
//                                                 Navigator.of(context).pop(),
//                                             child: const Text('Close'),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//                                 },
//                                 icon: const Icon(Icons.straighten, size: 16),
//                                 label: const Text("Size Guide"),
//                                 style: TextButton.styleFrom(
//                                   foregroundColor: Colors.pink,
//                                   textStyle: const TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 16),

//                           // Size Options
//                           Wrap(
//                             spacing: 12,
//                             runSpacing: 12,
//                             children: availableSizes.map((size) {
//                               bool isSelected = selectedSize == size;
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedSize = size;
//                                   });
//                                 },
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 200),
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 14,
//                                     horizontal: 20,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? Colors.black
//                                           : Colors.grey.shade300,
//                                       width: isSelected ? 2 : 1,
//                                     ),
//                                     borderRadius: BorderRadius.circular(30),
//                                     color: isSelected
//                                         ? Colors.black
//                                         : Colors.white,
//                                     boxShadow: isSelected
//                                         ? [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.black.withOpacity(0.1),
//                                               spreadRadius: 1,
//                                               blurRadius: 4,
//                                               offset: const Offset(0, 2),
//                                             ),
//                                           ]
//                                         : null,
//                                   ),
//                                   child: Text(
//                                     size,
//                                     style: TextStyle(
//                                       color: isSelected
//                                           ? Colors.white
//                                           : Colors.black,
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Action Buttons
//                     Column(
//                       children: [
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: selectedSize != null
//                                 ? () {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text(
//                                           'Added ${widget.product.name} (Size: $selectedSize) to cart',
//                                         ),
//                                         backgroundColor: Colors.green,
//                                       ),
//                                     );
//                                     context.read<CartBloc>().add(
//                                           AddToCartEvent(
//                                             product: widget.product,
//                                             selectedSize: selectedSize!,
//                                           ),
//                                         );
//                                     setState(() {
//                                       isAddedToCart = true;
//                                     });
//                                   }
//                                 : null,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.black,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                               elevation: 2,
//                             ),
//                             child: const Text(
//                               'Add to Cart',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         // SizedBox(
//                         //   width: double.infinity,
//                         //   height: 50,
//                         //   child: OutlinedButton(
//                         //     onPressed: selectedSize != null
//                         //         ? () {
//                         //             // TODO: Implement buy now functionality
//                         //             ScaffoldMessenger.of(context).showSnackBar(
//                         //               SnackBar(
//                         //                 content: Text(
//                         //                   'Proceeding to checkout for ${widget.product.name} (Size: $selectedSize)',
//                         //                 ),
//                         //                 backgroundColor: Colors.blue,
//                         //               ),
//                         //             );
//                         //           }
//                         //         : null,
//                         //     style: OutlinedButton.styleFrom(
//                         //       side: const BorderSide(color: Colors.black),
//                         //       shape: RoundedRectangleBorder(
//                         //         borderRadius: BorderRadius.circular(25),
//                         //       ),
//                         //     ),
//                         //     child: const Text(
//                         //       'Buy Now',
//                         //       style: TextStyle(
//                         //         fontSize: 16,
//                         //         fontWeight: FontWeight.w600,
//                         //         color: Colors.black,
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     // Additional Information
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.blue.shade100),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.local_shipping,
//                                   color: Colors.blue.shade600, size: 20),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Free Shipping *',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.blue.shade700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Icon(Icons.replay,
//                                   color: Colors.blue.shade600, size: 20),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Easy Returns',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.blue.shade700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget _showSizeRequiredBottomSheet(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Center(
//           child: Container(
//             width: 40,
//             height: 4,
//             margin: const EdgeInsets.only(bottom: 12),
//             decoration: BoxDecoration(
//               color: Colors.grey[400],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//         ),
//         const Text(
//           'Select a Size',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 10),
//         const Text(
//           'Please select a size before adding this item to your cart.',
//           style: TextStyle(fontSize: 14),
//         ),
//         const SizedBox(height: 20),
//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'OK',
//               style: TextStyle(
//                 color: Colors.pink,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
import 'package:cached_network_image/cached_network_image.dart';
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
    // double discountedPrice = widget.product.price -
    //     (widget.product.price * (widget.product.discount / 100));

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: MediaQuery.of(context).size.width > 600
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Check if a size is selected
                    if (selectedSize == null) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        enableDrag: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => _showSizeRequiredBottomSheet(context),
                      );
                      return;
                    }
                    // Add the product to the cart
                    context.read<CartBloc>().add(AddToCartEvent(
                          product: widget.product,
                          selectedSize: selectedSize!,
                        ));
                    // Show a snackbar to indicate the product has been added to the cart
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.product.name} added to cart!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    setState(() {
                      isAddedToCart = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    selectedSize == null ? 'Select Size & Add to Cart' : 'Add to Cart',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.product.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(15),
            ),
            icon: const Icon(
              CupertinoIcons.heart,
              size: 26,
              color: Colors.black,
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
                icon: const Icon(CupertinoIcons.cart, size: 26, color: Colors.black),
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
        children: [
          // Product Image Section
          Container(
            width: MediaQuery.of(context).size.width ,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
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
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.image,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                        errorWidget: (context, url, error) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.zoom_in,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Product Details Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Product Description
                Text(
                  widget.product.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // Price Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      product_price(product: widget.product, isDetail: true),
                      const SizedBox(height: 4),
                      Text(
                        'Inclusive of all taxes',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Size Selection Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Size",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text('Size Guide'),
                              content: const Text(
                                'Size guide information will be displayed here.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.straighten, size: 16),
                      label: const Text("Size Guide"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.pink,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Size Options
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: availableSizes.map((size) {
                    bool isSelected = selectedSize == size;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSize = size;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          color: isSelected ? Colors.black : Colors.white,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          size,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Additional Information
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_shipping,
                        color: Colors.blue.shade600, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Free Shipping *',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.replay, color: Colors.blue.shade600, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Easy Returns',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 100), // Extra space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    widget.product.sizes.sort((a, b) => a.compareTo(b));
    widget.product.sizes.isNotEmpty
        ? availableSizes = widget.product.sizes
        : availableSizes = ['XS', 'S', 'M', 'L', 'XL', '2XL'];

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Product Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ZoomableImageScreen(
                              imageUrl: widget.product.image),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.product.image,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.86,
                          errorWidget: (context, url, error) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.zoom_in,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 30),

            // Right side - Product Details
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: BorderSide.strokeAlignCenter),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Product Description
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Price Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          product_price(
                              product: widget.product, isDetail: true),
                          const SizedBox(height: 4),
                          Text(
                            'Inclusive of all taxes',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Size Selection Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Select Size",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Size Guide'),
                                        content: const Text(
                                          'Size guide information will be displayed here.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.straighten, size: 16),
                                label: const Text("Size Guide"),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.pink,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Size Options
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: availableSizes.map((size) {
                              bool isSelected = selectedSize == size;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSize = size;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: selectedSize != null
                                ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Added ${widget.product.name} (Size: $selectedSize) to cart',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    context.read<CartBloc>().add(
                                          AddToCartEvent(
                                            product: widget.product,
                                            selectedSize: selectedSize!,
                                          ),
                                        );
                                    setState(() {
                                      isAddedToCart = true;
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Additional Information
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_shipping,
                                  color: Colors.blue.shade600, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Free Shipping *',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.replay,
                                  color: Colors.blue.shade600, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Easy Returns',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _showSizeRequiredBottomSheet(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.straighten,
              size: 32,
              color: Colors.orange.shade600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Title
          const Text(
            'Select a Size',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            'Please select a size before adding this item to your cart. You can find the size guide in the product details.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}