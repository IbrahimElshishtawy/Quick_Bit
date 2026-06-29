import 'package:equatable/equatable.dart';
import '../../domain/entities/cafe_entity.dart';
import '../../domain/entities/food_item_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CafeEntity> cafes;
  final String selectedTag;
  final List<CafeEntity> filteredCafes;

  const HomeLoaded({
    required this.cafes,
    this.selectedTag = 'All',
    required this.filteredCafes,
  });

  @override
  List<Object?> get props => [cafes, selectedTag, filteredCafes];

  HomeLoaded copyWith({
    List<CafeEntity>? cafes,
    String? selectedTag,
    List<CafeEntity>? filteredCafes,
  }) {
    return HomeLoaded(
      cafes: cafes ?? this.cafes,
      selectedTag: selectedTag ?? this.selectedTag,
      filteredCafes: filteredCafes ?? this.filteredCafes,
    );
  }
}

class HomeMenuLoading extends HomeState {
  final List<CafeEntity> cafes; // Keep cafes while loading menu
  const HomeMenuLoading(this.cafes);

  @override
  List<Object?> get props => [cafes];
}

class HomeMenuLoaded extends HomeState {
  final List<CafeEntity> cafes;
  final CafeEntity selectedCafe;
  final List<FoodItemEntity> menuItems;

  const HomeMenuLoaded({
    required this.cafes,
    required this.selectedCafe,
    required this.menuItems,
  });

  @override
  List<Object?> get props => [cafes, selectedCafe, menuItems];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
