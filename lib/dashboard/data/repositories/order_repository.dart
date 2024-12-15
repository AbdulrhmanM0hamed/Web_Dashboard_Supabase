import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderRepository {
  final SupabaseClient _supabaseClient;

  OrderRepository(this._supabaseClient);

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
}
