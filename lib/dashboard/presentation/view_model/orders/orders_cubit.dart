import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepository _orderRepository;
  StreamSubscription? _ordersSubscription;
  final _audioPlayer = AudioPlayer();
  List<OrderModel> _previousOrders = [];

  OrdersCubit(this._orderRepository) : super(OrdersInitial()) {
    _subscribeToOrders();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    await _audioPlayer.setAsset('assets/sounds/tone.mp3');
  }

  void _subscribeToOrders() {
    _ordersSubscription = _orderRepository.ordersStream.listen((orders) {
      if (_previousOrders.isNotEmpty && orders.length > _previousOrders.length) {
        _playNotificationSound();
      }
      _previousOrders = orders;
      emit(OrdersLoaded(orders));
    });
  }

  Future<void> _playNotificationSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.setAsset('assets/sounds/tone.mp3');
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing notification sound: $e');
    }
  }

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

  @override
  Future<void> close() async {
    await _audioPlayer.dispose();
    await _ordersSubscription?.cancel();
    return super.close();
  }
}
