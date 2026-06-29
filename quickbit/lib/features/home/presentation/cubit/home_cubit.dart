import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/cafe_entity.dart';
import '../../domain/usecases/get_cafes_usecase.dart';
import '../../domain/usecases/get_menu_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCafesUseCase getCafesUseCase;
  final GetMenuUseCase getMenuUseCase;

  List<CafeEntity> _allCafes = [];
  final List<String> _favorites = []; // Store favorite food item/cafe IDs

  HomeCubit({
    required this.getCafesUseCase,
    required this.getMenuUseCase,
  }) : super(HomeInitial());

  Future<void> fetchCafes() async {
    emit(HomeLoading());
    final result = await getCafesUseCase(const NoParams());
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (cafes) {
        _allCafes = cafes;
        emit(HomeLoaded(cafes: cafes, filteredCafes: cafes));
      },
    );
  }

  void filterByTag(String tag) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      List<CafeEntity> filtered;
      if (tag == 'All') {
        filtered = _allCafes;
      } else {
        filtered = _allCafes.where((cafe) => cafe.tags.contains(tag)).toList();
      }
      emit(currentState.copyWith(selectedTag: tag, filteredCafes: filtered));
    }
  }

  Future<void> fetchMenu(CafeEntity cafe) async {
    final List<CafeEntity> currentCafes = _allCafes;
    emit(HomeMenuLoading(currentCafes));

    final result = await getMenuUseCase(cafe.id);
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (menuItems) => emit(HomeMenuLoaded(
        cafes: currentCafes,
        selectedCafe: cafe,
        menuItems: menuItems,
      )),
    );
  }

  void toggleFavorite(String itemId) {
    if (_favorites.contains(itemId)) {
      _favorites.remove(itemId);
    } else {
      _favorites.add(itemId);
    }
    // Simple state trigger to rebuild views that listen to favorites
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith()); // Trigger state reload
    }
  }

  bool isFavorite(String itemId) => _favorites.contains(itemId);

  List<CafeEntity> getFavoriteCafes() {
    return _allCafes.where((cafe) => _favorites.contains(cafe.id)).toList();
  }
}
