import 'package:ecommerce/components/widgets/product_shimmer.dart';
import 'package:ecommerce/components/widgets/product_tile.dart';
import 'package:ecommerce/screens/cart/views/cart_screen.dart';
import 'package:ecommerce/screens/home/blocs/get_product_bloc/get_product_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_repository/product_repository.dart';
import 'package:shimmer/shimmer.dart';

class CategoryPage extends StatelessWidget {
  final String categoryTitle;

  const CategoryPage({required this.categoryTitle, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(categoryTitle,style: const TextStyle(fontWeight: FontWeight.w600),),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,

        actions: [
        // InkWell(
        //   onTap: (){},
        //   // hoverColor: Colors.white,
        //   child: Container(
        //     margin: EdgeInsets.all(10),
        //     alignment: Alignment.center,
        //     width: 37,
        //     decoration: BoxDecoration(
        //         // color: Color(0xffF7F8F8),
        //         borderRadius: BorderRadius.circular(10)),
        //     child: Icon(CupertinoIcons.search,size: 27,),
        //     // child: SvgPicture.asset(
        //     //   'assets/icons/search.svg',
        //     //   height: 25,
        //     //   width: 25,
        //     // ),
        //   ),
        // ),
        InkWell(
          onTap: (){},
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: const Icon(CupertinoIcons.heart,size: 27,),
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const CartScreen(),
            ));
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: const Icon(Icons.shopping_bag_outlined,size: 27,),
          ),
        ),
        const SizedBox(width: 10,)
      ],
      ),
      body: BlocBuilder<GetProductBloc, GetProductState>(
        builder: (context, state) {
          if (state is GetProductSuccess) {
            // Filter products based on the category
            final filteredProducts = state.products
                .where((product) => product.category == categoryTitle)
                .toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderWithCountAndTitle(filteredProducts.length),
                    const SizedBox(height: 14),
                    filteredProducts.isEmpty
                        ? Center(child: Text("No products found in $categoryTitle"))
                        : _buildProductGrid(screenWidth, filteredProducts),
                  ],
                ),
              ),
            );
          } else if (state is GetProductLoading) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: _buildProductShimmer(screenWidth),
            );
          } else {
            return const Center(child: Text("An error occurred..."));
          }
        },
      ),
    );
  }

  // Combined widget for the results count and "Shop All {categoryTitle}" header
  Widget _buildHeaderWithCountAndTitle(int resultCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Shop All $categoryTitle',
        //   style: TextStyle(
        //     fontSize: 18,
        //     fontWeight: FontWeight.w800,
        //   ),
        // ),
        Text(
          'Found $resultCount Results',
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        
      ],
    );
  }

  Widget _buildProductGrid(double screenWidth, List<Product> products) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: calculateCrossAxisCount(screenWidth),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 9 / 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductTile(product: products[index]);
      },
    );
  }

  Widget _buildProductShimmer(double screenWidth) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: calculateCrossAxisCount(screenWidth),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 9 / 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 16,
                width: screenWidth * 0.4,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 14,
                width: screenWidth * 0.3,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 14,
                width: screenWidth * 0.2,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
