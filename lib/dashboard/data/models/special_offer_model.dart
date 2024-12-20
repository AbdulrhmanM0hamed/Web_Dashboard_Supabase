import 'package:equatable/equatable.dart';

class SpecialOfferModel extends Equatable {
  final String? id;
  final String title;
  final String subtitle;
  final String? image1;
  final String? image2;
  final String? description;
  final double? offerPrice;
  final List<String> includedItems;
  final DateTime? validUntil;
  final List<String> terms;
  final String? categoryId;
  final Map<String, dynamic>? customizations;
  final int totalOrders;
  final int viewsCount;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SpecialOfferModel({
    this.id,
    required this.title,
    required this.subtitle,
    this.image1,
    this.image2,
    this.description,
    this.offerPrice,
    this.includedItems = const [],
    this.validUntil,
    this.terms = const [],
    this.categoryId,
    this.customizations,
    this.totalOrders = 0,
    this.viewsCount = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory SpecialOfferModel.fromJson(Map<String, dynamic> json) {
    return SpecialOfferModel(
      id: json['id'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      image1: json['image1'],
      image2: json['image2'],
      description: json['description'],
      offerPrice: json['offer_price'] != null ? double.parse(json['offer_price'].toString()) : null,
      includedItems: List<String>.from(json['included_items'] ?? []),
      validUntil: json['valid_until'] != null ? DateTime.parse(json['valid_until']) : null,
      terms: List<String>.from(json['terms'] ?? []),
      categoryId: json['category_id'],
      customizations: json['customizations'],
      totalOrders: json['total_orders'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson({bool forCreation = false}) {
    final Map<String, dynamic> data = {
      'title': title,
      'subtitle': subtitle,
      'image1': image1,
      'image2': image2,
      'description': description,
      'offer_price': offerPrice,
      'included_items': includedItems,
      'valid_until': validUntil?.toIso8601String(),
      'terms': terms,
      'category_id': categoryId,
      'customizations': customizations,
      'total_orders': totalOrders,
      'views_count': viewsCount,
      'is_active': isActive,
    };

    if (!forCreation && id != null) {
      data['id'] = id;
    }

    return data;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        image1,
        image2,
        description,
        offerPrice,
        includedItems,
        validUntil,
        terms,
        categoryId,
        customizations,
        totalOrders,
        viewsCount,
        isActive,
        createdAt,
        updatedAt,
      ];

  SpecialOfferModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? image1,
    String? image2,
    String? description,
    double? offerPrice,
    List<String>? includedItems,
    DateTime? validUntil,
    List<String>? terms,
    String? categoryId,
    Map<String, dynamic>? customizations,
    int? totalOrders,
    int? viewsCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SpecialOfferModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      image1: image1 ?? this.image1,
      image2: image2 ?? this.image2,
      description: description ?? this.description,
      offerPrice: offerPrice ?? this.offerPrice,
      includedItems: includedItems ?? this.includedItems,
      validUntil: validUntil ?? this.validUntil,
      terms: terms ?? this.terms,
      categoryId: categoryId ?? this.categoryId,
      customizations: customizations ?? this.customizations,
      totalOrders: totalOrders ?? this.totalOrders,
      viewsCount: viewsCount ?? this.viewsCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
