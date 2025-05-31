part of 'add_product_bloc.dart';

abstract class AddProductState extends Equatable {
  const AddProductState();

  @override
  List<Object?> get props => [];
}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductFailure extends AddProductState {
  final String error;

  const AddProductFailure(this.error);

  @override
  List<Object?> get props => [error];
}
