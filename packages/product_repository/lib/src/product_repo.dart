// import 'dart:typed_data';

import 'dart:typed_data';

import 'models/models.dart';

abstract class ProductRepo{
  Future<List<Product>> getProducts();
  Stream<List<Product>> getProductStream();

  Future<void> addProduct(Product product);

  Future<String> sendImage(Uint8List file, String name);
}