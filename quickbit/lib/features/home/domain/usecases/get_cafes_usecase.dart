import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cafe_entity.dart';
import '../repositories/home_repository.dart';

class GetCafesUseCase implements UseCase<List<CafeEntity>, NoParams> {
  final HomeRepository repository;

  GetCafesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CafeEntity>>> call(NoParams params) async {
    return await repository.getCafes();
  }
}
