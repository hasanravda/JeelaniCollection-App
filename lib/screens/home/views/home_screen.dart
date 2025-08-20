// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_element

import 'package:ecommerce/admin/blocs/upload_picture_bloc/upload_picture_bloc.dart';
import 'package:ecommerce/admin/screens/add_product.dart';
import 'package:ecommerce/components/widgets/product_tile.dart';
import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/screens/cart/views/cart_screen.dart';
import 'package:ecommerce/screens/category/category_page.dart';
import 'package:ecommerce/screens/home/blocs/get_product_bloc/get_product_bloc.dart';
import 'package:ecommerce/screens/home/views/app_bar.dart';
import 'package:ecommerce/screens/login/screens/login_redirect_widget.dart';
import 'package:ecommerce/screens/login/screens/profile_update_page.dart';
import 'package:ecommerce/screens/order/my_orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:product_repository/product_repository.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // To track the currently selected item
  // final GlobalKey<LoginRedirectWidgetState> _loginKey = GlobalKey();
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      // buildHomeContent(context), // Bcoz context cant be used in initState
      CartScreen(),
      MyOrdersScreen(),
      // StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     final user = snapshot.data;
      //     if (user != null) {
      //       return ProfileUpdatePage(
      //         phoneNumber: user.phoneNumber ?? '',
      //         uid: user.uid,
      //       );
      //     } else if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     } else {
      //       return const LoginRedirectWidget();
      //       // return Container();
      //     }
      //   },
      // ),
      _buildProfileScreen()
    ]; // Initial fetch of products
    context.read<GetProductBloc>().add(GetProduct());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _refreshProducts(BuildContext context) async {
    context.read<GetProductBloc>().add(GetProduct());
  }

  Widget _buildProfileScreen() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const LoginRedirectWidget();
    return ProfileUpdatePage(
      phoneNumber: user.phoneNumber ?? '',
      uid: user.uid,
    );
  }

  // Widget _buildPageForIndex(int index) {
  //   switch (index) {
  //     case 0:
  //       return buildHomeContent(context);
  //     case 1:
  //       return CartScreen();
  //     case 2:
  //       return MyOrdersScreen();
  //     // case 3:R
  //     //   return _buildUserTab(context);
  //     default:
  //       return buildHomeContent(context); // Default to home content
  //   }
  // }

  // bool _hasShownLoginSheet = false;

// Widget _buildUserTab(BuildContext context) {
//   return StreamBuilder<User?>(
//     stream: FirebaseAuth.instance.authStateChanges(),
//     builder: (context, snapshot) {
//       final user = snapshot.data;

//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       if (user != null) {
//         _hasShownLoginSheet = false; // Reset when user is logged in
//         return ProfileUpdatePage(
//           phoneNumber: user.phoneNumber ?? '',
//           uid: user.uid,
//         );
//       } else {
//         if (!_hasShownLoginSheet) {
//           // ✅ Only show once
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (mounted) {
//               // LoginRedirectWidget.showLoginSheet(context);
//             }
//           });
//           _hasShownLoginSheet = true;
//         }

//         return const LoginRedirectWidget();
//       }
//     },
//   );
// }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => UploadPictureBloc(FirebaseProductRepo()),
                  child: AddProductScreen(),
                ),
              ));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: appBar(context),
      backgroundColor: Colors.white,

      // body: buildHomeContent(context),
      // body: _buildPageForIndex(_selectedIndex),
      body: [
        buildHomeContent(context),
        ..._pages, // Use the selected page based on index
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        // elevation: 1,
        selectedItemColor: Colors.blue,
        showSelectedLabels: true,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/home.svg'),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: SvgPicture.asset('assets/icons/search.svg'),
          //   label: 'Search',
          // ),
          BottomNavigationBarItem(
            // icon: SvgPicture.asset('assets/icons/search.svg'),
            icon: Icon(CupertinoIcons.cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/receipt.svg'),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/person.svg'),
            // icon: Icon(CupertinoIcons.person),
            label: 'User',
          ),
        ],
      ),
    );
  }

  Widget buildHomeContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(
            children: [
              _buildCategorySection(),
              const SizedBox(height: 14),
              _buildPopularSection(),
              const SizedBox(height: 14),

              // Products list
              BlocBuilder<GetProductBloc, GetProductState>(
                builder: (context, state) {
                  if (state is GetProductSuccess) {
                    return _buildProductGrid(screenWidth, state.products);
                  } else if (state is GetProductLoading) {
                    return _buildProductShimmer(screenWidth);
                  } else {
                    return const Center(
                      child: Text("An error has occurred ..."),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            Text(
              'Show all',
              style: TextStyle(fontSize: 13),
            )
          ],
        ),
        const SizedBox(height: 14),
        BlocBuilder<GetProductBloc, GetProductState>(
          builder: (context, state) {
            if (state is GetProductLoading) {
              return _buildCategoryShimmer();
            } else {
              return _buildCategoryList();
            }
          },
        ),
      ],
    );
  }

  Widget _buildPopularSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Popular this week',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        Text(
          'Show all',
          style: TextStyle(fontSize: 13),
        )
      ],
    );
  }

  Widget _buildCategoryList() {
    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () {
              // Navigate to CategoryPage and pass the category title
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryPage(categoryTitle: category.title),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      category.imageUrl,
                      width: 150,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      // color: Colors.black.withOpacity(0.7),
                      color: Colors.black54,
                      child: Text(
                        category.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(double screenWidth, List<Product> products) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
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

  Widget _buildCategoryShimmer() {
    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Placeholder count for shimmer
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 150,
              height: 180,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductShimmer(double screenWidth) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: calculateCrossAxisCount(screenWidth),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 9 / 16,
      ),
      itemCount: 6, // Placeholder count for shimmer
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image shimmer
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 8),

              // Title shimmer
              Container(
                height: 16,
                width: screenWidth * 0.4, // Adjust the width as needed
                color: Colors.white,
              ),
              const SizedBox(height: 8),

              // Description shimmer
              Container(
                height: 14,
                width: screenWidth * 0.3, // Adjust the width as needed
                color: Colors.white,
              ),
              const SizedBox(height: 8),

              // Price shimmer
              Container(
                height: 14,
                width: screenWidth * 0.2, // Adjust the width as needed
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}

int calculateCrossAxisCount(double screenWidth) {
  if (screenWidth <= 600) {
    return 2; // Mobile screens
  } else if (screenWidth <= 1200) {
    return 3; // Tablet screen
  } else {
    return 4; // Desktop screen
  }
}
