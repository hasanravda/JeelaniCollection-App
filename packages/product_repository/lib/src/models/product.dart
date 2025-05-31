import 'package:product_repository/src/entities/product_entity.dart';

// import 'package:product_repository/src/entities/entities.dart';

class Product{
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

  Product({
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

 Product copyWith({
    String? pId,
    String? name,
    String? image,
    String? description,
    String? category,
    int? price,
    int? discount,
    bool? isAvailable,
    List<String>? sizes,
    DateTime? dateAdded,
  }) {
    return Product(
      pId: pId ?? this.pId,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      isAvailable: isAvailable ?? this.isAvailable,
      sizes: sizes ?? this.sizes,
      dateAdded: dateAdded ?? this.dateAdded
    );
  }


  ProductEntity toEntity(){
    return ProductEntity(
      pId : pId,
      name : name,
      image : image,
      description : description,
      category: category,
      price : price,
      isAvailable : isAvailable,
      discount : discount,
      sizes : sizes,
    );
  }

  static Product fromEntity(ProductEntity entity){
    return Product(
      pId : entity.pId,
      name : entity.name,
      image : entity.image,
      description : entity.description,
      category : entity.category,
      price : entity.price,
      isAvailable : entity.isAvailable,
      discount : entity.discount,
      sizes : entity.sizes,
      dateAdded: entity.dateAdded
    );
  }
  
  // Convert Product to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'pId': pId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'isAvailable': isAvailable,
      'discount': discount,
      'sizes': sizes,
      'dateAdded': dateAdded?.toIso8601String(), // convert DateTime to String
    };
  }

  // Convert Map to Product (for JSON decoding)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      pId: json['pId'],
      name: json['name'],
      image: json['image'],
      category: json['category'],
      description: json['description'],
      price: json['price'],
      isAvailable: json['isAvailable'],
      discount: json['discount'],
      sizes: List<String>.from(json['sizes'] ?? []),
      dateAdded: json['dateAdded'] != null
        ? DateTime.tryParse(json['dateAdded'])
        : null,
    );
  }

  // Convert Product to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'pId': pId,
      'name': name,
      'image': image,
      'description': description,
      'category': category,
      'price': price,
      'isAvailable': isAvailable,
      'discount': discount,
      'sizes': sizes,
      'dateAdded': dateAdded?.toIso8601String(), // convert DateTime to String
    };
  }

  @override
  String toString() {
    return 'Product{pId: $pId, name: $name, description: $description, category: $category, price: $price, isAvailable: $isAvailable, discount: $discount, sizes: $sizes, dateAdded: $dateAdded }';
  }
}