import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _keyCachedUser = 'CACHED_USER';

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(_keyCachedUser);
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await sharedPreferences.setString(_keyCachedUser, json.encode(user.toJson()));
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await sharedPreferences.remove(_keyCachedUser);
    } catch (e) {
      throw const CacheException();
    }
  }
}
