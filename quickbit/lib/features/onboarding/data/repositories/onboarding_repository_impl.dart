import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, bool>> cacheOnboardingCompleted() async {
    try {
      final result = await localDataSource.cacheOnboardingCompleted();
      return Right(result);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() async {
    try {
      final result = await localDataSource.isOnboardingCompleted();
      return Right(result);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
