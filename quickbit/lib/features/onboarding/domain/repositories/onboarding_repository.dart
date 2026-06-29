import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, bool>> cacheOnboardingCompleted();
  Future<Either<Failure, bool>> isOnboardingCompleted();
}
