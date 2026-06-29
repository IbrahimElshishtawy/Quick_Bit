import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

class CacheOnboardingCompleted implements UseCase<bool, NoParams> {
  final OnboardingRepository repository;

  CacheOnboardingCompleted(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.cacheOnboardingCompleted();
  }
}
