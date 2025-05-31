import 'package:ecommerce/admin/screens/add_product.dart';
import 'package:ecommerce/screens/detail_page/views/detail_screen.dart';
import 'package:ecommerce/screens/home/blocs/get_product_bloc/get_product_bloc.dart';
import 'package:ecommerce/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_repository/product_repository.dart';

final _navKey = GlobalKey<NavigatorState>();

class MyAppRouter {
  GoRouter router = GoRouter(
    navigatorKey: _navKey,
    initialLocation: '/',
    routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) {
        return BlocBuilder<GetProductBloc, GetProductState>(
          builder: (context, state) {
            if (state is GetProductSuccess) {
              return const HomeScreen(); // Products successfully loaded
            } else if (state is GetProductLoading) {
              return const Center(
                  child: CircularProgressIndicator()); // Loading state
            } else if (state is GetProductFailure) {
              return const Center(
                  child: Text('Failed to load productss')); // Failure state
            }
            return const Center(
                child: CircularProgressIndicator()); // Default loading state
          },
        );
      },
    ),
    GoRoute(
        name: 'productDetail',
        path: '/product/:pid',
        builder: (context, state) {
          final product = state.extra as Product;
          // Pass productId to the details screen
          return DetailScreen(product: product);
        },
      ),
      GoRoute(
        name: 'addProduct',
        path: '/add',
        builder: (context, state) {
          return const AddProductScreen();
        },
      ),
  ]);
}
