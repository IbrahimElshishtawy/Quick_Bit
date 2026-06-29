import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

class IsOnboardingCompleted implements UseCase<bool, NoParams> {
  final OnboardingRepository repository;

  IsOnboardingCompleted(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isOnboardingCompleted();
  }
}
