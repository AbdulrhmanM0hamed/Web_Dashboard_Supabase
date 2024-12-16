import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());
    try {
      final supabase = Supabase.instance.client;

      // Get products count
      final productsCount = await supabase
          .from('products')
          .count();

      // Get categories count
      final categoriesCount = await supabase
          .from('categories')
          .count();

      // Get users count
      final usersCount = await supabase
          .from('profiles')
          .count();

      // Get orders count
      final ordersCount = await supabase
          .from('orders')
          .count();

      emit(DashboardLoaded(
        productsCount: productsCount,
        categoriesCount: categoriesCount,
        usersCount: usersCount,
        ordersCount: ordersCount,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
