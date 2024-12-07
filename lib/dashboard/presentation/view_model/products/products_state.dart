part of 'products_cubit.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsFetched extends ProductsState {
  final List<ProductModel> products;
  ProductsFetched(this.products);
}

class ProductAddSuccess extends ProductsState {}

class ProductUpdateSuccess extends ProductsState {}

class ProductDeleteSuccess extends ProductsState {}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}

class ProductsMostSoldLoading extends ProductsState {}

class ProductsMostSoldLoaded extends ProductsState {
  final ProductModel product;

  ProductsMostSoldLoaded(this.product);
}

class ProductsMostSoldError extends ProductsState {
  final String message;

  ProductsMostSoldError(this.message);
}
