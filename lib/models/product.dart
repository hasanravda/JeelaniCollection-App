import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String pId;
  final String name;
  final String image;
  final String description;
  final String category;
  final double price;
  final double discount;
  final bool isAvailable;

  const Product({
    required this.pId,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.price,
    required this.discount,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [pId, name, image, description, category, price, discount, isAvailable];
  
}


// final List<Product> products = [
//   Product(
//     pId: '001',
//     name: 'Floral Dress',
//     image: 'https://adn-static1.nykaa.com/nykdesignstudio-images/pub/media/catalog/product/9/7/976cec8MSKD1493_1.jpg?rnd=20200526195200&tr=w-512',
//     description: 'Elegant floral dress for summer lorem ipsum dolar sit ',
//     category: 'Dresses',
//     price: 1999,
//     discount: 10,
//     isAvailable: true,
//   ),
//   Product(
//     pId: '002',
//     name: 'Denim Jacket',
//     image: 'https://adn-static1.nykaa.com/nykdesignstudio-images/pub/media/catalog/product/f/1/f174b0c0HA258T01_1.jpg?rnd=20200526195200&tr=w-512',
//     description: 'Stylish denim jacket for all seasons',
//     category: 'Jackets',
//     price: 89.99,
//     discount: 15,
//     isAvailable: true,
//   ),
//   Product(
//     pId: '003',
//     name: 'Casual T-Shirt',
//     image: 'https://adn-static1.nykaa.com/nykdesignstudio-images/pub/media/catalog/product/d/0/d0233c0TP503WHBK_1.jpg?rnd=20200526195200&tr=w-512',
//     description: 'Comfortable casual t-shirt',
//     category: 'Tops',
//     price: 19.99,
//     discount: 20,
//     isAvailable: true,
//   ),
//   Product(
//     pId: '004',
//     name: 'Maxi Skirt',
//     image: 'https://adn-static1.nykaa.com/nykdesignstudio-images/pub/media/catalog/product/d/4/d43d8bbTP0269DP2-Multi-Color_1.jpg?rnd=20200526195200&tr=w-512',
//     description: 'Flowy maxi skirt for everyday wear',
//     category: 'Skirts',
//     price: 39.99,
//     discount: 25,
//     isAvailable: false,
//   ),
//   Product(
//     pId: '005',
//     name: 'Blouse',
//     image: 'https://adn-static1.nykaa.com/nykdesignstudio-images/pub/media/catalog/product/5/c/5cdb67e124126WHIT_1.jpg?rnd=20200526195200&tr=w-512',
//     description: 'Chic blouse with intricate details',
//     category: 'Tops',
//     price: 29.99,
//     discount: 05,
//     isAvailable: true,
//   ),
//   Product(
//     pId: '006',
//     name: 'High-Waist Jeans',
//     image: 'https://adn-static1.nykaa.com/nykdesignstudio-images/pub/media/catalog/product/1/c/1c6e7bfBT011192_1.jpg?rnd=20200526195200&tr=w-512',
//     description: 'Comfortable high-waist jeans',
//     category: 'Pants',
//     price: 59.99,
//     discount: 10,
//     isAvailable: true,
//   ),
//   // Product(
//   //   pId: '007',
//   //   name: 'Cardigan Sweater',
//   //   image: 'assets/images/cardigan_sweater.jpg',
//   //   description: 'Warm cardigan sweater for chilly days',
//   //   category: 'Sweaters',
//   //   price: 69.99,
//   //   discount: 0.20,
//   //   isAvailable: false,
//   // ),
//   // Product(
//   //   pId: '008',
//   //   name: 'Summer Shorts',
//   //   image: 'assets/images/summer_shorts.jpg',
//   //   description: 'Lightweight shorts perfect for summer',
//   //   category: 'Shorts',
//   //   price: 24.99,
//   //   discount: 0.15,
//   //   isAvailable: true,
//   // ),
//   // Product(
//   //   pId: '009',
//   //   name: 'Leather Jacket',
//   //   image: 'assets/images/leather_jacket.jpg',
//   //   description: 'Trendy leather jacket for a bold look',
//   //   category: 'Jackets',
//   //   price: 129.99,
//   //   discount: 0.30,
//   //   isAvailable: true,
//   // ),
//   // Product(
//   //   pId: '010',
//   //   name: 'Leggings',
//   //   image: 'assets/images/workout_leggings.jpg',
//   //   description: 'Stretchy workout leggings for all activities',
//   //   category: 'Activewear',
//   //   price: 34.99,
//   //   discount: 0.20,
//   //   isAvailable: true,
//   // ),
// ];