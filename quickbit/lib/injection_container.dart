import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'core/network/api_client.dart';
import 'features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';
import 'features/onboarding/domain/usecases/cache_onboarding_completed.dart';
import 'features/onboarding/domain/usecases/is_onboarding_completed.dart';
import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'features/shared_auth/data/datasources/auth_local_datasource.dart';
import 'features/shared_auth/data/datasources/auth_remote_datasource.dart';
import 'features/shared_auth/data/repositories/auth_repository_impl.dart';
import 'features/shared_auth/domain/repositories/auth_repository.dart';
import 'features/shared_auth/domain/usecases/login_usecase.dart';
import 'features/shared_auth/domain/usecases/register_usecase.dart';
import 'features/shared_auth/domain/usecases/forgot_password_usecase.dart';
import 'features/shared_auth/bloc/auth_bloc.dart';
import 'features/home/data/datasources/home_remote_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_cafes_usecase.dart';
import 'features/home/domain/usecases/get_menu_usecase.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  // Core
  sl.registerLazySingleton(() => ApiClient(sl()));

  // Features - Onboarding
  // Cubit
  sl.registerFactory(() => OnboardingCubit(cacheOnboardingCompleted: sl()));
  // Use cases
  sl.registerLazySingleton(() => CacheOnboardingCompleted(sl()));
  sl.registerLazySingleton(() => IsOnboardingCompleted(sl()));
  // Repository
  sl.registerLazySingleton<OnboardingRepository>(() => OnboardingRepositoryImpl(sl()));
  // Data sources
  sl.registerLazySingleton<OnboardingLocalDataSource>(() => OnboardingLocalDataSourceImpl(sl()));

  // Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      forgotPasswordUseCase: sl(),
      localDataSource: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sl()));

  // Features - Home
  // Cubit
  sl.registerFactory(() => HomeCubit(getCafesUseCase: sl(), getMenuUseCase: sl()));
  // Use cases
  sl.registerLazySingleton(() => GetCafesUseCase(sl()));
  sl.registerLazySingleton(() => GetMenuUseCase(sl()));
  // Repository
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(sl()));

  // Features - Cart (Registered here because FoodDetails uses it)
  sl.registerLazySingleton(() => CartBloc());
}
