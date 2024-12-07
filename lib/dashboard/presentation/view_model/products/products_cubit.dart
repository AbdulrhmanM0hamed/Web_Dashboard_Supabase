import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/core/services/image_picker_service.dart';
import 'package:supabase_dashboard/core/services/supabase_service.dart';
import 'package:supabase_dashboard/dashboard/data/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  final _supabase = Supabase.instance.client;
  final  _supabaseService = SupabaseService();
  Future<void> loadProducts() async {
    try {
      emit(ProductsLoading());
      
      final response = await _supabase
          .from('products')
          .select('*, categories(*)')
          .order('created_at', ascending: false);
      
      final products = (response as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
      
      emit(ProductsFetched(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
      rethrow;
    }
  }

  Future<void> createProduct(ProductModel product) async {
    try {
      emit(ProductsLoading());

      final productData = {
        ...product.toJson(forCreation: true),
        'created_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('products').insert(productData);
      
      await loadProducts();
      emit(ProductAddSuccess());
    } catch (e) {
      emit(ProductsError(e.toString()));
      rethrow;
    }
  }

  Future<void> updateProduct(String? id, ProductModel product) async {
    if (id == null) {
      emit(ProductsError('معرف المنتج غير صالح'));
      return;
    }

    try {
      emit(ProductsLoading());

      await _supabase
          .from('products')
          .update({
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'stock': product.stock,
            'category_id': product.categoryId,
            'image_url': product.imageUrl,
            'is_available': product.isAvailable,
            'has_discount': product.hasDiscount,
            'discount_percentage': product.discountPercentage,
            'discount_price': product.discountPrice,
          })
          .eq('id', id);
      
      await loadProducts();
      emit(ProductUpdateSuccess());
    } catch (e) {
      emit(ProductsError(e.toString()));
      rethrow;
    }
  }

  Future<void> deleteProduct(String? id) async {
    if (id == null) {
      emit(ProductsError('معرف المنتج غير صالح'));
      return;
    }

    try {
      emit(ProductsLoading());

      final product = await _supabase
          .from('products')
          .select()
          .eq('id', id)
          .single();

      if (product != null && product['image_url'] != null) {
        await ImagePickerService.deleteImage(product['image_url'], isProduct: true);
      }

      await _supabase
          .from('products')
          .delete()
          .eq('id', id);
      
      // Load products again to update the UI
      final response = await _supabase
          .from('products')
          .select('*, categories(*)')
          .order('created_at', ascending: false);
      
      final products = (response as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
      
      emit(ProductsFetched(products));
      emit(ProductDeleteSuccess());
    } catch (e) {
      emit(ProductsError(e.toString()));
      rethrow;
    }
  }

  Future<void> loadMostSoldProduct() async {
    try {
      emit(ProductsMostSoldLoading());
      final product = await _supabaseService.getMostSoldProduct();
      if (product != null) {
        emit(ProductsMostSoldLoaded(ProductModel.fromJson(product)));
      } else {
        emit(ProductsMostSoldError('لا يوجد منتجات'));
      }
    } catch (e) {
      emit(ProductsMostSoldError(e.toString()));
    }
  }

  Future<void> incrementSoldCount(String productId) async {
    try {
      await _supabaseService.incrementProductSoldCount(productId);
      await loadProducts(); // تحديث قائمة المنتجات
      await loadMostSoldProduct(); // تحديث المنتج الأكثر مبيعاً
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
