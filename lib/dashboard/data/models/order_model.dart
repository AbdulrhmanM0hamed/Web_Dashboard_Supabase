import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required String name,
    required String id,
    required String userId,
    required List<OrderItemModel> items,
    required double totalAmount,
    required String status,
    required DateTime createdAt,
    String? deliveryAddress,
    String? phoneNumber,
  }) : super(
          name: name,
          id: id,
          userId: userId,
          items: items,
          totalAmount: totalAmount,
          status: status,
          createdAt: createdAt,
          deliveryAddress: deliveryAddress,
          phoneNumber: phoneNumber,
        );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      name: json['name'] as String? ?? '',
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      items: (json['items'] as List?)
              ?.map((item) =>
                  OrderItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      deliveryAddress: json['delivery_address'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'user_id': userId,
      'items':
          (items as List<OrderItemModel>).map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'delivery_address': deliveryAddress,
      'phone_number': phoneNumber,
    };
  }
}

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required String productId,
    required String productName,
    required int quantity,
    required double price,
    String? imageUrl,
  }) : super(
          productId: productId,
          productName: productName,
          quantity: quantity,
          price: price,
          imageUrl: imageUrl,
        );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'image_url': imageUrl,
    };
  }
}
