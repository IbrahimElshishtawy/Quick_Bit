import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cafe_entity.dart';
import '../entities/food_item_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CafeEntity>>> getCafes();
  Future<Either<Failure, List<FoodItemEntity>>> getMenu(String cafeId);
}
