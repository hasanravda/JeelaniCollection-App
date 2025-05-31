import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart';

part 'get_product_event.dart';
part 'get_product_state.dart';

class GetProductBloc extends Bloc<GetProductEvent, GetProductState> {
  final ProductRepo _productRepo;
  late StreamSubscription<List<Product>>? _subscription;

  GetProductBloc(this._productRepo) : super(GetProductInitial()) {
    on<GetProduct>((event, emit) async {
      emit(GetProductLoading());
      try {
        List<Product> products = await _productRepo.getProducts();
        emit(GetProductSuccess(products));
      } catch (e) {
        emit(GetProductFailure());
      }

      // emit(GetProductLoading());
      // _subscription = _productRepo.getProductStream().listen(
      //   (products) {
      //     emit(GetProductSuccess(products));
      //   },
      //   onError: (error) {
      //     emit(GetProductFailure());
      //   },
      // );

    });
  }

   @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
