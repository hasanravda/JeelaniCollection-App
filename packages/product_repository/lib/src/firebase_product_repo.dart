// ignore_for_file: annotate_overrides

import 'dart:developer';
import 'dart:typed_data';
// import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:product_repository/product_repository.dart';

class FirebaseProductRepo implements ProductRepo {
  final productCollection = FirebaseFirestore.instance.collection('products');

  // Fetch products one-time
  Future<List<Product>> getProducts() async {
    try {
      final querySnapshot = await productCollection.get();
      log("Documents retrieved: ${querySnapshot.docs.length}");

      // return await pizzaCollection
      //   .get()
      //   .then((value) => value.docs.map((e) =>
      //     Pizza.fromEntity(PizzaEntity.fromDocument(e.data()))
      //   ).toList());

      return querySnapshot.docs.map((doc) {
        log("Document data: ${doc.data()}");
        final data = doc.data();
        final productEntity = ProductEntity.fromDocument(data);
        return Product.fromEntity(productEntity);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Stream<List<Product>> getProductStream() {
    return productCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final productEntity = ProductEntity.fromDocument(data);
        return Product.fromEntity(productEntity);
      }).toList();
    });
  }


    @override
  Future<String> sendImage(Uint8List file, String name) async{
    try {
      Reference firebaseStorageRef = FirebaseStorage
        .instance
        .ref()
        .child(name);

      // await firebaseStorageRef.putBlob(file);
      await firebaseStorageRef.putData(
        file,
        // SettableMetadata(
        //   contentType: 'image/jpeg',
        //   // customMetadata: {'picked-file-path': file.path},
        // )
      );
      return await firebaseStorageRef.getDownloadURL();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Add product logic
  Future<void> addProduct(Product product) async {
    try {  
      final docRef = productCollection.doc(); // Generates a new document ID
      final productWithId = product.copyWith(pId: docRef.id);
      
      await docRef.set(productWithId.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // @override
  // Future<void> createProduct(Product product) async{
  //   try {
  //     return await productCollection
  //       .doc(product.pId)
  //       .set(product.toEntity().toDocument());
       
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }
}
