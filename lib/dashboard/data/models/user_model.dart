import 'package:supabase_dashboard/dashboard/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.email,
    super.name,
    super.phoneNumber,
    super.provider = AuthProviderType.email, 
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      provider: _getProviderType(json['provider'] ?? 'email'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'provider': provider.name,
    };
  }

  static AuthProviderType _getProviderType(String provider) {
    switch (provider.toLowerCase()) {
      case 'google':
        return AuthProviderType.google;
      case 'facebook':
        return AuthProviderType.facebook;
      default:
        return AuthProviderType.email;
    }
  }
}
