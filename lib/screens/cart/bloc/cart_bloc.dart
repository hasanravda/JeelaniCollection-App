import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/repository/cart_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository = CartRepository();

  CartBloc() : super(CartLoading()) {
    // Handle AddToCartEvent
    on<AddToCartEvent>((event, emit) async {
      log("Adding product to cart: ${event.product.name}");
      // if (state is CartLoaded) {
      //   final currentState = state as CartLoaded;
      //   final updatedCart = List<CartItem>.from(currentState.cartItems)
      //     ..add(CartItem(product: event.product, quantity: 1));
      //   emit(CartLoaded(cartItems: updatedCart));
      // }
      try {
        log("Adding product to cart in repository");
        await _repository.addCartItem(CartItem(
            product: event.product,
            quantity: 1,
            selectedSize: event.selectedSize));
        final cartItems = await _repository.fetchCartItems();
        emit(CartLoaded(cartItems: cartItems));
        Future.delayed(Duration.zero, () => add(CalculateBillingEvent()));
        log("Product added to cart: ${event.product.name}");
      } catch (e) {
        log("Error adding product to cart: $e");
        emit(CartError(message: e.toString()));
      }
    });

    // Handle LoadCartEvent
    on<LoadCartEvent>((event, emit) async {
      emit(CartLoading());
      try {
        log("Loading cart items from repository");
        final cartItems = await _repository.fetchCartItems();
        log("Fetched ${cartItems.length} items from repository");
        emit(CartLoaded(cartItems: cartItems));
        Future.delayed(Duration.zero, () => add(CalculateBillingEvent()));
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    });

    // Handle RemoveFromCartEvent
    on<RemoveFromCartEvent>((event, emit) async {
      if (state is CartLoaded) {
        // final currentState = state as CartLoaded;
        try {
          await _repository.removeCartItem(event.item);
          // final updatedCart = List<CartItem>.from(currentState.cartItems)
          //   ..remove(event.item);
          final cartItems = await _repository.fetchCartItems();
          emit(CartLoaded(cartItems: cartItems));
          Future.delayed(Duration.zero, () => add(CalculateBillingEvent()));
        } catch (e) {
          emit(CartError(message: e.toString()));
        }
      }
    });

    // Handle UpdateCartItem Event
    on<UpdateCartItem>(_onUpdateCartItem);

    on<ClearCartEvent>((event, emit) async {
      if (state is CartLoaded) {
        try {
          await _repository.clearCart();
          emit(CartEmpty());
        } catch (e) {
          emit(CartError(message: e.toString()));
        }
      }
    });

    // Handle CalculateBillingEvent
    on<CalculateBillingEvent>(_onCalculateBilling);
  }

  // Method to handle UpdateCartItem event
  void _onUpdateCartItem(UpdateCartItem event, Emitter<CartState> emit) async{
    if (state is CartLoaded) {
      final cartItems = (state as CartLoaded).cartItems;

      final updatedCartItems = cartItems.map((item) {
        if (item.product.pId == event.cartItem.product.pId) {
          return CartItem(
              product: item.product,
              quantity: event.newQuantity,
              selectedSize: item.selectedSize);
        }
        return item;
      }).toList();

      // Persist updated cart
     await _repository.saveCart(updatedCartItems);
      log("Updated cart item: ${event.cartItem.product.name} to quantity ${event.newQuantity}");

      emit(CartLoaded(cartItems: updatedCartItems));
      Future.delayed(Duration.zero, () => add(CalculateBillingEvent()));
    }
  }

  void _onCalculateBilling(
      CalculateBillingEvent event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      log("Calculating billing");
      final cartItems = (state as CartLoaded).cartItems;

      double bagTotal = 0;
      double subTotal = 0;

      for (var item in cartItems) {
        final mrp = item.product.price;
        final discountPercent = item.product.discount;
        final discountedPrice = item.product.discount == 0
            ? mrp
            : mrp - (mrp * (discountPercent / 100));
        final quantity = item.quantity;

        bagTotal += mrp * quantity;
        subTotal += discountedPrice * quantity;
      }

      final discountOnMRP = bagTotal - subTotal; // Total discount on MRP
      // Calculate convenience fee as 2% of the subtotal
      final convenienceFee =
          double.parse((subTotal * 0.02).toStringAsFixed(2)).ceil().toDouble();
      final finalTotal = (subTotal + convenienceFee).ceil().ceilToDouble();
      // Total amount to be paid

      emit(CartLoaded(
        cartItems: cartItems,
        bagTotal: bagTotal,
        discountOnMRP: discountOnMRP,
        subTotal: subTotal,
        convenienceFee: convenienceFee,
        finalTotal: finalTotal,
      ));
    }
  }
}
