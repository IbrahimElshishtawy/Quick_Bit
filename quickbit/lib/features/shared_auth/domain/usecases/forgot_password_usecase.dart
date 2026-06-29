import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickbit/core/errors/failures.dart';
import 'package:quickbit/core/usecases/usecase.dart';
import 'package:quickbit/features/shared_auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<Unit, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}
