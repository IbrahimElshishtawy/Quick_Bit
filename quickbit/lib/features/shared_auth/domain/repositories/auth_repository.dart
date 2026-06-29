import 'package:dartz/dartz.dart';
import 'package:quickbit/core/errors/failures.dart';
import 'package:quickbit/features/shared_auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register(String name, String email, String password);
  Future<Either<Failure, Unit>> forgotPassword(String email);
}
