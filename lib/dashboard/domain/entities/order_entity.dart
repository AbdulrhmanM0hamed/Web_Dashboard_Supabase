import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String name; 
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final String? deliveryAddress;
  final String? phoneNumber;

  const OrderEntity({
    required this.name,
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.deliveryAddress,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        name,
        id,
        userId,
        items,
        totalAmount,
        status,
        createdAt,
        deliveryAddress,
        phoneNumber,
      ];
}

class OrderItem extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final String? imageUrl;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [productId, productName, quantity, price, imageUrl];
}
