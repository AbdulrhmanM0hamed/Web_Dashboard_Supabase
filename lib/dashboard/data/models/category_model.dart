import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String? id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isActive;

  const CategoryModel({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }

  @override
  List<Object?> get props => [id, name, description, imageUrl, isActive];

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
    );
  }
}
