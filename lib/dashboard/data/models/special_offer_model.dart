import 'package:equatable/equatable.dart';

class SpecialOfferModel extends Equatable {
  final String? id;
  final String title;
  final String subtitle;
  final String? image1;
  final String? image2;
  final String? image3;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SpecialOfferModel({
    this.id,
    required this.title,
    required this.subtitle,
    this.image1,
    this.image2,
    this.image3,
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
      image3: json['image3'],
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
      'image3': image3,
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
        image3,
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
    String? image3,
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
      image3: image3 ?? this.image3,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
