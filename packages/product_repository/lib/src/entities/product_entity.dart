// import 'package:product_repository/src/entities/entities.dart';


import 'package:cloud_firestore/cloud_firestore.dart';

class ProductEntity{
  String pId;
  String name;
  String image;
  String description;
  String category;
  int price;
  int discount;
  bool isAvailable; 
  List<String> sizes; // New field
  final DateTime? dateAdded;


  ProductEntity({
    required this.pId,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.price,
    required this.discount,
    required this.isAvailable,
    required this.sizes,
    this.dateAdded,

});


  Map<String, Object?> toDocument() {
    return {
      'pId': pId,
      'name': name,
      'image': image,
      'description': description,
      'category': category,
      'price': price,
      'discount': discount,
      'isAvailable':isAvailable,
      'sizes': sizes,
      'dateAdded': dateAdded,

    };
  }

  static ProductEntity fromDocument(Map<String, dynamic> doc) {
    return ProductEntity(
      pId: doc['pId'],
      name: doc['name'],
      image: doc['image'],
      description: doc['description'],
      category: doc['category'],
      price: doc['price'],
      discount: doc['discount'],    
      isAvailable: doc['isAvailable'],
      sizes: List<String>.from(doc['sizes'] ?? []),  
      dateAdded: doc['dateAdded'] != null
    ? (doc['dateAdded'] as Timestamp).toDate()
    : null,

    );
  }
}
