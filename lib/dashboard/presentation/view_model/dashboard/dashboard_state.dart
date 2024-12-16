part of 'dashboard_cubit.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int productsCount;
  final int categoriesCount;
  final int usersCount;
  final int ordersCount;

  DashboardLoaded({
    required this.productsCount,
    required this.categoriesCount,
    required this.usersCount,
    required this.ordersCount,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
