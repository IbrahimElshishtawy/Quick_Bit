import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/cache_onboarding_completed.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final CacheOnboardingCompleted cacheOnboardingCompleted;
  int _currentPage = 0;

  OnboardingCubit({required this.cacheOnboardingCompleted}) : super(OnboardingInitial());

  int get currentPage => _currentPage;

  void setPageIndex(int index) {
    _currentPage = index;
    emit(OnboardingPageChanged(index));
  }

  Future<void> completeOnboarding() async {
    final result = await cacheOnboardingCompleted(const NoParams());
    result.fold(
      (failure) => emit(OnboardingCompletedState()), // Even if cache fails, proceed to login
      (success) => emit(OnboardingCompletedState()),
    );
  }
}
