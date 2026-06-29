import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<void> forgotPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (email.contains('@') && password.length >= 6) {
      return UserModel(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@')[0].toUpperCase(),
        email: email,
        token: 'jwt_mock_token_12345',
      );
    } else {
      throw const ServerException('Invalid email or password (min 6 characters).');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (name.isNotEmpty && email.contains('@') && password.length >= 6) {
      return UserModel(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        token: 'jwt_mock_token_12345',
      );
    } else {
      throw const ServerException('Please enter valid info and password >= 6 characters.');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (!email.contains('@')) {
      throw const ServerException('Invalid email address.');
    }
  }
}
