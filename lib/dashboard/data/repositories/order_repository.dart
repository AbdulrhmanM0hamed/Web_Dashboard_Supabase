import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderRepository {
  final SupabaseClient _supabaseClient;
  final _ordersController = StreamController<List<OrderModel>>.broadcast();

  OrderRepository(this._supabaseClient) {
    _initializeRealtimeSubscription();
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _supabaseClient
          .from('orders')
          .select()
          .order('created_at', ascending: false);


      if (response == null) {
        return [];
      }

      return (response as List)
          .map((order) => OrderModel.fromJson(order as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _supabaseClient
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final response = await _supabaseClient
          .from('orders')
          .select()
          .eq('id', orderId)
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<OrderModel>> get ordersStream => _ordersController.stream;

  void _initializeRealtimeSubscription() {
    _supabaseClient
        .from('orders')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .listen((List<Map<String, dynamic>> data) {
          final orders = data.map((order) => OrderModel.fromJson(order)).toList();
          _ordersController.add(orders);
        });
  }

  void dispose() {
    _ordersController.close();
  }
}
