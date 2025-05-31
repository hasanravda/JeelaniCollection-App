part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final double bagTotal;
  final double discountOnMRP;
  final double subTotal;
  final double convenienceFee;
  final double finalTotal;

  const CartLoaded({
    required this.cartItems,
    this.bagTotal = 0.0,
    this.discountOnMRP = 0.0,
    this.subTotal = 0.0,
    this.convenienceFee = 0.0,
    this.finalTotal = 0.0,
    });

  @override
  List<Object> get props => [cartItems,
    bagTotal,
    discountOnMRP,
    subTotal,
    convenienceFee,
    finalTotal,
  ];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}

class CartEmpty extends CartState {}
