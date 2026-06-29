import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickbit/core/errors/failures.dart';
import 'package:quickbit/core/usecases/usecase.dart';
import 'package:quickbit/features/shared_auth/domain/entities/user_entity.dart';
import 'package:quickbit/features/shared_auth/domain/repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(params.name, params.email, params.password);
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const RegisterParams({required this.name, required this.email, required this.password});

  @override
  List<Object?> get props => [name, email, password];
}
