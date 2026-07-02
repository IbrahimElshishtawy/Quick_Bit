import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbit/core/constants/assets.dart';
import 'package:quickbit/core/constants/dimensions.dart';
import 'package:quickbit/injection_container.dart';
import 'package:quickbit/features/login/presentation/pages/login_page.dart';
import 'package:quickbit/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:quickbit/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:quickbit/features/onboarding/presentation/widgets/onboarding_step_card.dart';
import 'package:quickbit/features/onboarding/presentation/widgets/onboarding_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  final List<OnboardingSlideData> _slides = [
    const OnboardingSlideData(
      title: 'Discover campus cafés',
      description: 'Find the best spots to grab a bite or a coffee across the entire campus.',
      imageUrl: AppAssets.onboardingDiscover,
    ),
    const OnboardingSlideData(
      title: 'Order in seconds',
      description: 'Browse menus, customize your meals, and pay securely right from your phone.',
      imageUrl: AppAssets.onboardingOrder,
    ),
    const OnboardingSlideData(
      title: 'Pick up without waiting',
      description: 'Receive a unique pickup code and collect your order at your selected time. No more queues!',
      imageUrl: AppAssets.onboardingPickup,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompletedState) {
            _navigateToLogin();
          }
        },
        builder: (context, state) {
          final cubit = context.read<OnboardingCubit>();
          final currentPage = cubit.currentPage;

          return Scaffold(
            body: Stack(
              children: [
                // Slide Views (Images as Background)
                Positioned.fill(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      cubit.setPageIndex(index);
                    },
                    itemBuilder: (context, index) {
                      return OnboardingStepCard(data: _slides[index]);
                    },
                  ),
                ),

                // Top Title & Skip Button Overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.lg,
                        vertical: AppDimensions.sm,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'QuickBite',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextButton(
                            onPressed: () => cubit.completeOnboarding(),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Navigation Area Overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: OnboardingIndicator(
                      totalSteps: _slides.length,
                      currentStep: currentPage,
                      isLastStep: currentPage == _slides.length - 1,
                      onNext: () {
                        if (currentPage < _slides.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          cubit.completeOnboarding();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
