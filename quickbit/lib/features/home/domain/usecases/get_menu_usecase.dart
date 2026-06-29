import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/food_item_entity.dart';
import '../repositories/home_repository.dart';

class GetMenuUseCase implements UseCase<List<FoodItemEntity>, String> {
  final HomeRepository repository;

  GetMenuUseCase(this.repository);

  @override
  Future<Either<Failure, List<FoodItemEntity>>> call(String cafeId) async {
    return await repository.getMenu(cafeId);
  }
}
