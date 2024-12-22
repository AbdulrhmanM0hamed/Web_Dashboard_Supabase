import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String categoryId;
  final bool hasDiscount;
  final int? discountPercentage;
  final double? discountPrice;
  final int soldCount;
  final bool isAvailable;
  final int stock;

  final bool isOrganic;
  final double rating;
  final int ratingCount;
  final double caloriesPer100g;
  final String expiryName;
  final double weight;

  const ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.categoryId,
    required this.hasDiscount,
    this.discountPercentage,
    this.discountPrice,
    this.soldCount = 0,
    required this.isAvailable,
    required this.stock,
    this.isOrganic = false,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.caloriesPer100g = 0.0,
    this.expiryName = '',
    this.weight = 0.0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      imageUrl: json['image_url'],
      categoryId: json['category_id'] ?? '',
      hasDiscount: json['has_discount'] ?? false,
      discountPercentage:
          int.tryParse(json['discount_percentage']?.toString() ?? '0'),
      discountPrice: double.tryParse(json['discount_price']?.toString() ?? '0'),
      soldCount: int.tryParse(json['sold_count']?.toString() ?? '0') ?? 0,
      isAvailable: json['is_available'] ?? true,
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      isOrganic: json['is_organic'] ?? false,
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      ratingCount: int.tryParse(json['rating_count']?.toString() ?? '0') ?? 0,
      caloriesPer100g:
          double.tryParse(json['calories_per_100g']?.toString() ?? '0') ?? 0.0,
      expiryName: json['expiry_name'] ?? '',
      weight: double.tryParse(json['weight']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson({bool forCreation = false}) {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category_id': categoryId,
      'has_discount': hasDiscount,
      'discount_percentage': discountPercentage,
      'discount_price': discountPrice,
      'sold_count': soldCount,
      'is_available': isAvailable,
      'stock': stock,
      'is_organic': isOrganic,
      'rating': rating,
      'rating_count': ratingCount,
      'calories_per_100g': caloriesPer100g,
      'expiry_name': expiryName,
      'weight': weight
    };

    if (!forCreation && id != null) {
      data['id'] = id;
    }

    return data;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        categoryId,
        hasDiscount,
        discountPercentage,
        discountPrice,
        soldCount,
        isAvailable,
        stock,
        isOrganic,
        rating,
        ratingCount,
        caloriesPer100g,
        expiryName,
        weight
      ];

  ProductModel copyWith(
      {String? id,
      String? name,
      String? description,
      double? price,
      String? imageUrl,
      String? categoryId,
      bool? hasDiscount,
      int? discountPercentage,
      double? discountPrice,
      int? soldCount,
      bool? isAvailable,
      int? stock,
      bool? isOrganic,
      double? rating,
      int? ratingCount,
      double? caloriesPer100g,
      String? expiryName,
      double? expiryNumber
      }
      ) {
    return ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        categoryId: categoryId ?? this.categoryId,
        hasDiscount: hasDiscount ?? this.hasDiscount,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        discountPrice: discountPrice ?? this.discountPrice,
        soldCount: soldCount ?? this.soldCount,
        isAvailable: isAvailable ?? this.isAvailable,
        stock: stock ?? this.stock,
        isOrganic: isOrganic ?? this.isOrganic,
        rating: rating ?? this.rating,
        ratingCount: ratingCount ?? this.ratingCount,
        caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
        expiryName: expiryName ?? this.expiryName,
        weight: expiryNumber ?? this.weight);
  }
}
