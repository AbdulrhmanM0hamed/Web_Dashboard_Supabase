import 'dart:developer' as dev;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  // Products
  static const String _productsTable = 'products';

  // Create
  Future<Map<String, dynamic>?> createProduct(Map<String, dynamic> data) async {
    try {
      dev.log('Creating product with data: ');
      final response = await _client
          .from(_productsTable)
          .insert(data)
          .select()
          .single();
      dev.log('Product created successfully', name: 'SupabaseService');
      return response;
    } catch (e) {
      dev.log('Error creating product:$e', name: 'SupabaseService');
      rethrow; 
    }
  }

  // Read
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      dev.log('Fetching products...', name: 'SupabaseService');
      final response = await _client
          .from(_productsTable)
          .select()
          .order('created_at', ascending: false);
      dev.log('Products fetched successfully:', name: 'SupabaseService');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      dev.log('Error getting products:$e', name: 'SupabaseService');
      rethrow; 
    }
  }

  // Update
  Future<bool> updateProduct(String? id, Map<String, dynamic> data) async {
    if (id == null || id.isEmpty) {
      throw ArgumentError('معرف المنتج مطلوب للتحديث');
    }

    try {
      dev.log('Updating product $id with data: $data', name: 'SupabaseService');
      
      final updateData = Map<String, dynamic>.from(data)..remove('id');
      
      final response = await _client
          .from(_productsTable)
          .update(updateData)
          .eq('id', id)
          .select()
          .single();
          
      dev.log('Product updated successfully:', name: 'SupabaseService');
      return response != null;
    } catch (e) {
      dev.log('Error updating product:$e ', name: 'SupabaseService');
      rethrow;
    }
  }

  // Delete
  Future<bool> deleteProduct(String? id) async {
    if (id == null || id.isEmpty) {
      throw ArgumentError('معرف المنتج مطلوب للحذف');
    }

    try {
      dev.log('Deleting product ', name: 'SupabaseService');
      final response = await _client
          .from(_productsTable)
          .delete()
          .eq('id', id)
          .select()
          .single();
      dev.log('Product deleted successfully: ', name: 'SupabaseService');
      return response != null;
    } catch (e) {
      dev.log('Error deleting product: $e', name: 'SupabaseService');
      rethrow;
    }
  }

  // Get product by ID
  Future<Map<String, dynamic>?> getProductById(String id) async {
    try {
      dev.log('Fetching product ', name: 'SupabaseService');
      final response = await _client
          .from(_productsTable)
          .select()
          .eq('id', id)
          .single();
      dev.log('Product fetched successfully: ', name: 'SupabaseService');
      return response;
    } catch (e) {
      dev.log('Error getting product:$e ', name: 'SupabaseService');
      rethrow;
    }
  }

  // Get most sold product
  Future<Map<String, dynamic>?> getMostSoldProduct() async {
    try {
      final response = await _client
          .from(_productsTable)
          .select()
          .order('sold_count', ascending: false)
          .limit(1)
          .single();
      return response;
    } catch (e) {
      dev.log('Error getting most sold product: $e', name: 'SupabaseService');
      return null;
    }
  }

  // Update product sold count
  Future<void> incrementProductSoldCount(String productId) async {
    try {
      // Get current sold count
      final product = await _client
          .from(_productsTable)
          .select('sold_count')
          .eq('id', productId)
          .single();
      
      final currentCount = product['sold_count'] as int? ?? 0;
      
      // Increment sold count
      await _client
          .from(_productsTable)
          .update({'sold_count': currentCount + 1})
          .eq('id', productId);
    } catch (e) {
      dev.log('Error incrementing product sold count: $e', name: 'SupabaseService');
      rethrow;
    }
  }

  // Categories
  static const String _categoriesTable = 'categories';

  // Create Category
  Future<void> createCategory(Map<String, dynamic> categoryData) async {
    try {
      dev.log('SupabaseService: Starting category creation...', name: 'SupabaseService');
      dev.log('SupabaseService: Category data: ', name: 'SupabaseService');
      
      final response = await _client
          .from(_categoriesTable)
          .insert(categoryData)
          .select()
          .single();
      
      dev.log('SupabaseService: Category created successfully: ', name: 'SupabaseService');
    } catch (e) {
      dev.log('SupabaseService: Error creating category: ', name: 'SupabaseService');
      throw Exception('فشل في إنشاء الفئة: $e');
    }
  }

  // Get Categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      dev.log('Fetching categories...', name: 'SupabaseService');
      final response = await _client
          .from(_categoriesTable)
          .select()
          .order('created_at', ascending: false);
      dev.log('Categories fetched successfully: ', name: 'SupabaseService');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      dev.log('Error getting categories: $e', name: 'SupabaseService');
      rethrow;
    }
  }

  // Update Category
  Future<bool> updateCategory(String? id, Map<String, dynamic> data) async {
    if (id == null || id.isEmpty) {
      throw ArgumentError('معرف الفئة مطلوب للتحديث');
    }

    try {
      dev.log('Updating category $id with data: $data', name: 'SupabaseService');
      final updateData = Map<String, dynamic>.from(data)..remove('id');
      final response = await _client
          .from(_categoriesTable)
          .update(updateData)
          .eq('id', id)
          .select()
          .single();
      dev.log('Category updated successfully: ', name: 'SupabaseService');
      return response != null;
    } catch (e) {
      dev.log('Error updating category: $e', name: 'SupabaseService');
      rethrow;
    }
  }

  // Delete Category
  Future<bool> deleteCategory(String? id) async {
    if (id == null || id.isEmpty) {
      throw ArgumentError('معرف الفئة مطلوب للحذف');
    }

    try {
      dev.log('Deleting category ', name: 'SupabaseService');
      final response = await _client
          .from(_categoriesTable)
          .delete()
          .eq('id', id)
          .select()
          .single();
      dev.log('Category deleted successfully: ', name: 'SupabaseService');
      return response != null;
    } catch (e) {
      dev.log('Error deleting category: $e', name: 'SupabaseService');
      rethrow;
    }
  }

  // Get Category by ID
  Future<Map<String, dynamic>?> getCategoryById(String? id) async {
    if (id == null || id.isEmpty) {
      throw ArgumentError('معرف الفئة مطلوب');
    }

    try {
      dev.log('Fetching category ', name: 'SupabaseService');
      final response = await _client
          .from(_categoriesTable)
          .select()
          .eq('id', id)
          .single();
      dev.log('Category fetched successfully: ', name: 'SupabaseService');
      return response;
    } catch (e) {
      dev.log('Error getting category: $e', name: 'SupabaseService');
      rethrow;
    }
  }

  // Categories Methods
  Future<List<Map<String, dynamic>>> getCategoriesNew() async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      dev.log('Error in getCategories: $e', name: 'SupabaseService');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> createCategoryNew(Map<String, dynamic> categoryData) async {
    try {
      final response = await _client
          .from('categories')
          .insert(categoryData)
          .select()
          .single();
      return response;
    } catch (e) {
      dev.log('Error in createCategory: $e', name: 'SupabaseService');
      rethrow;
    }
  }

  Future<bool> updateCategoryNew(String id, Map<String, dynamic> categoryData) async {
    try {
      await _client
          .from('categories')
          .update(categoryData)
          .eq('id', id);
      return true;
    } catch (e) {
      dev.log('Error in updateCategory: $e', name: 'SupabaseService');
      return false;
    }
  }

  Future<bool> deleteCategoryNew(String id) async {
    try {
      await _client
          .from('categories')
          .delete()
          .eq('id', id);
      return true;
    } catch (e) {
      dev.log('Error in deleteCategory: $e', name: 'SupabaseService');
      return false;
    }
  }

  // Special Offers
  Future<List<Map<String, dynamic>>> getSpecialOffers() async {
    try {
      final response = await _client
          .from('special_offers')
          .select()
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error getting special offers: $e');
    }
  }

  Future<void> addSpecialOffer(Map<String, dynamic> offer) async {
    try {
      await _client.from('special_offers').insert(offer);
    } catch (e) {
      throw Exception('Error adding special offer: $e');
    }
  }

  Future<void> updateSpecialOffer(String id, Map<String, dynamic> offer) async {
    try {
      await _client
          .from('special_offers')
          .update(offer)
          .eq('id', id);
    } catch (e) {
      throw Exception('Error updating special offer: $e');
    }
  }

  Future<void> deleteSpecialOffer(String id) async {
    try {
      await _client.from('special_offers').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error deleting special offer: $e');
    }
  }

  Future<void> updateSpecialOfferStatus(String id, bool isActive) async {
    try {
      await _client
          .from('special_offers')
          .update({'is_active': isActive})
          .eq('id', id);
    } catch (e) {
      throw Exception('Error updating special offer status: $e');
    }
  }
}
