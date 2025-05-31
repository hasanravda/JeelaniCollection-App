import 'package:ecommerce/components/cards/cart_card.dart';
import 'package:ecommerce/components/widgets/billing_section.dart';
import 'package:ecommerce/screens/cart/bloc/cart_bloc.dart';
import 'package:ecommerce/screens/checkout/checkout_card.dart';
import 'package:ecommerce/screens/cart/views/empty_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc()..add(LoadCartEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              const Text(
                "Your Cart",
                style: TextStyle(color: Colors.black),
              ),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoaded) {
                    return Text(
                      "${state.cartItems.length} items",
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CartLoaded) {
              debugPrint("Cart Loaded with ${state.cartItems.length} items");
							if (state.cartItems.isEmpty) {
								return const EmptyCartScreen();
							}
							// Display cart items and billing section
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Cart items
                    cartItems(state),
                    const SizedBox(height: 10),
                    // Billing section
                    Padding(
											padding: const EdgeInsets.symmetric(horizontal: 14.0),
											child: const Divider(thickness: 1),
										),
                    BillingSection(state: state),
                  ],
                ),
              );
            } else if (state is CartError) {
              return Center(child: Text(state.message));
            } else {
              return const EmptyCartScreen();
            }
            return const SizedBox();
          },
        ),
        bottomNavigationBar: CheckoutCard(),
      ),
    );
  }

  Widget cartItems(CartLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
				shrinkWrap: true,
				physics: const NeverScrollableScrollPhysics(),
        itemCount: state.cartItems.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(state.cartItems[index].product.pId.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              context
                  .read<CartBloc>()
                  .add(RemoveFromCartEvent(state.cartItems[index]));
            },
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  SvgPicture.asset('assets/icons/trash.svg'),
                ],
              ),
            ),
            child: CartCard(cart: state.cartItems[index]),
          ),
        ),
      ),
    );
  }
}
