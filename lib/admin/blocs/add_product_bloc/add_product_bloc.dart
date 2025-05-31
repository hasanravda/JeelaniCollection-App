import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {

  final ProductRepo _productRepo;

  AddProductBloc(this._productRepo) : super(AddProductInitial()) {
    on<AddProductSubmitted>((event, emit) async{
      emit(AddProductLoading());
      
      try {
        await _productRepo.addProduct(event.product);
        emit(AddProductSuccess());
      } catch (e) {
        emit(AddProductFailure(e.toString()));
      }
    });
  }
}
