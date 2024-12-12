import 'package:equatable/equatable.dart';

enum AuthProviderType {
  email,
  google,
  facebook,
}

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? phoneNumber;
  final AuthProviderType provider;

  const UserEntity({
    required this.id,
    this.email,
    this.name,
    this.phoneNumber,
    this.provider = AuthProviderType.email,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        provider,
      ];
}
