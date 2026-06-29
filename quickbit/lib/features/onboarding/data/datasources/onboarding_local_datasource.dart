import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> cacheOnboardingCompleted();
  Future<bool> isOnboardingCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _keyOnboardingCompleted = 'ONBOARDING_COMPLETED';

  OnboardingLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> cacheOnboardingCompleted() async {
    try {
      return await sharedPreferences.setBool(_keyOnboardingCompleted, true);
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    try {
      return sharedPreferences.getBool(_keyOnboardingCompleted) ?? false;
    } catch (e) {
      throw const CacheException();
    }
  }
}
