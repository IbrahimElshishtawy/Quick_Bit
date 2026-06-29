import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cafe_entity.dart';
import '../../domain/entities/food_item_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CafeEntity>>> getCafes() async {
    try {
      final cafes = await remoteDataSource.getCafes();
      return Right(cafes);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FoodItemEntity>>> getMenu(String cafeId) async {
    try {
      final menu = await remoteDataSource.getMenu(cafeId);
      return Right(menu);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
