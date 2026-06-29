import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';

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
            body: SafeArea(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  gradient: RadialGradient(
                    center: Alignment(0.8, -0.8),
                    radius: 1.2,
                    colors: [
                      Color(0x14FF6B35),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Top Skip Button
                    Padding(
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
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextButton(
                            onPressed: () => cubit.completeOnboarding(),
                            child: Text(
                              'Skip',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Slide Views
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _slides.length,
                        onPageChanged: (index) {
                          cubit.setPageIndex(index);
                        },
                        itemBuilder: (context, index) {
                          return OnboardingSlideWidget(data: _slides[index]);
                        },
                      ),
                    ),

                    // Bottom Navigation Area
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.lg,
                        vertical: AppDimensions.xl,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppDimensions.radius3Xl),
                          topRight: Radius.circular(AppDimensions.radius3Xl),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 40,
                            offset: Offset(0, -8),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Dots Indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _slides.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                width: currentPage == index ? 24.0 : 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: currentPage == index
                                      ? AppColors.primary
                                      : AppColors.outlineVariant,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.xl),

                          // Next/Get Started Button
                          SizedBox(
                            width: double.infinity,
                            height: AppDimensions.buttonHeightLg,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryContainer,
                                foregroundColor: AppColors.onPrimaryContainer,
                                elevation: 4,
                                shadowColor: AppColors.primaryContainer.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () {
                                if (currentPage < _slides.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  cubit.completeOnboarding();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    currentPage == _slides.length - 1
                                        ? 'Get Started'
                                        : 'Next',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppColors.onPrimaryContainer,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.onPrimaryContainer.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: AppColors.onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // iOS indicator spacer
                          const SizedBox(height: AppDimensions.sm),
                          Container(
                            width: 120,
                            height: 5,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OnboardingSlideData {
  final String title;
  final String description;
  final String imageUrl;

  const OnboardingSlideData({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class OnboardingSlideWidget extends StatelessWidget {
  final OnboardingSlideData data;

  const OnboardingSlideWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      child: Column(
        children: [
          // Illustration Area with Glassmorphism shadow
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Image.network(
                    data.imageUrl,
                    width: 260,
                    height: 260,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.restaurant,
                      size: 120,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Title & Description
          Column(
            children: [
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppDimensions.md),
              Text(
                data.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
        ],
      ),
    );
  }
}
