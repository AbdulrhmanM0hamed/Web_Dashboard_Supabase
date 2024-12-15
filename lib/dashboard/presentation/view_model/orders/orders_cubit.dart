import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepository _orderRepository;

  OrdersCubit(this._orderRepository) : super(OrdersInitial());

  Future<void> loadOrders() async {
    try {
      emit(OrdersLoading());
      final orders = await _orderRepository.getOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _orderRepository.updateOrderStatus(orderId, newStatus);
      await loadOrders(); // إعادة تحميل الطلبات بعد التحديث
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'processing':
        return 'جارى المراجعة';
      case 'accepted':
        return 'مقبول';
      case 'completed':
        return 'مكتمل';
      case 'delivered':
        return 'تم التسليم';
      case 'canceled':
        return 'ملغي';
      default:
        return status;
    }
  }
}
