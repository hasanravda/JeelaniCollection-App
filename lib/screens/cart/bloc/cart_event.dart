part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;
  final String selectedSize;

  const AddToCartEvent({required this.product, required this.selectedSize});

  @override
  List<Object> get props => [product];
}
// New Event to Update Cart Item Quantity
class UpdateCartItem extends CartEvent {
  final CartItem cartItem;
  final int newQuantity;

  const UpdateCartItem(this.cartItem, this.newQuantity);

  @override
  List<Object> get props => [cartItem, newQuantity];
}


class RemoveFromCartEvent extends CartEvent {
  final CartItem item;

  const RemoveFromCartEvent(this.item);

  @override
  List<Object> get props => [item];
}

class ClearCartEvent extends CartEvent {}

class CalculateBillingEvent extends CartEvent {}

