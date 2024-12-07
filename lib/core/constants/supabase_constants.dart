import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConstants {
  static final supabase = Supabase.instance.client;
  
  // Tables
  static const String usersTable = 'users';
  static const String productsTable = 'products';
  static const String ordersTable = 'orders';
  static const String cartTable = 'cart';
  
  // Storage Buckets
  static const String productImagesBucket = 'product_images';
  static const String userImagesBucket = 'user_images';
  
  // RLS Policies
  static const String authenticatedOnly = 'authenticated_only';
  static const String publicAccess = 'public_access';
}
