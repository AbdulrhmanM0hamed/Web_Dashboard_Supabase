import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String? id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String categoryId;
  final String imageUrl;
  final bool isAvailable;
  final bool hasDiscount;
  final int? discountPercentage;
  final double? discountPrice;
  final int soldCount;

  const ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.imageUrl,
    required this.isAvailable,
    required this.hasDiscount,
    this.discountPercentage,
    this.discountPrice,
    this.soldCount = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      categoryId: json['category_id']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      isAvailable: json['is_available'] as bool? ?? true,
      hasDiscount: json['has_discount'] as bool? ?? false,
      discountPercentage: int.tryParse(json['discount_percentage']?.toString() ?? '0'),
      discountPrice: (json['discount_price'] is int)
          ? (json['discount_price'] as int).toDouble()
          : double.tryParse(json['discount_price']?.toString() ?? '0'),
      soldCount: int.tryParse(json['sold_count']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson({bool forCreation = false}) {
    final json = {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category_id': categoryId,
      'image_url': imageUrl,
      'is_available': isAvailable,
      'has_discount': hasDiscount,
      'discount_percentage': discountPercentage,
      'discount_price': discountPrice,
      'sold_count': soldCount,
    };

    if (!forCreation && id != null) {
      json['id'] = id;
    }

    return json;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        stock,
        categoryId,
        imageUrl,
        isAvailable,
        hasDiscount,
        discountPercentage,
        discountPrice,
        soldCount,
      ];

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? categoryId,
    String? imageUrl,
    bool? isAvailable,
    bool? hasDiscount,
    int? discountPercentage,
    double? discountPrice,
    int? soldCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountPrice: discountPrice ?? this.discountPrice,
      soldCount: soldCount ?? this.soldCount,
    );
  }
}
