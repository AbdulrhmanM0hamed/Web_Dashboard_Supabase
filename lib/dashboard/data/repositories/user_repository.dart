import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserRepository {
  final SupabaseClient _supabaseClient;

  UserRepository(this._supabaseClient);

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select('id, email, name, phone_number, created_at')
          .order('created_at', ascending: false);
      
      if (response == null) {
        return [];
      }

      return (response as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
    } catch (e) {
      print('Error fetching users: $e'); // Debug print
      rethrow; // رمي الخطأ للتعامل معه في الـ Cubit
    }
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await _supabaseClient
          .from('users')
          .select('id, , name, photo_url, phone_number, provider, created_at')
          .eq('id', id)
          .single();

      if (response != null) {
        return UserModel.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }
}
