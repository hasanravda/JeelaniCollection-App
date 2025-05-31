// import 'dart:math';
// import 'dart:typed_data';

import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart';

part 'upload_picture_event.dart';
part 'upload_picture_state.dart';

class UploadPictureBloc extends Bloc<UploadPictureEvent, UploadPictureState> {
  ProductRepo productRepo;
  
  UploadPictureBloc(this.productRepo) : super(UploadPictureLoading()) {
    on<UploadPicture>((event, emit) async{
      try {
        String url = await productRepo.sendImage(event.file,event.name);
        emit(UploadPictureSuccess(url));
      } catch (e) {
        emit(UploadPictureFailure());
        log(e.toString());
      }
    });
  }
}
