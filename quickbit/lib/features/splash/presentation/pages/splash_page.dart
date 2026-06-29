import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../injection_container.dart';
import '../../domain/usecases/is_onboarding_completed.dart';
import 'onboarding_page.dart';
import '../../../auth/presentation/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _floatAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _startTransitionTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startTransitionTimer() {
    Timer(const Duration(milliseconds: 3500), () async {
      if (!mounted) return;

      final checkOnboarding = sl<IsOnboardingCompleted>();
      final result = await checkOnboarding(const NoParams());
      
      bool isCompleted = false;
      result.fold((_) => isCompleted = false, (completed) => isCompleted = completed);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => isCompleted ? const LoginPage() : const OnboardingPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header / Logo Area
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.xxl),
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Image.network(
                          AppAssets.logo,
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.fastfood, size: 80, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Text(
                        'QuickBite',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        'Swift Campus Dining',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Central Illustration
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: child,
                  );
                },
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0FFF6B35),
                        blurRadius: 40,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: Image.network(
                    AppAssets.splashIllustration,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.delivery_dining,
                      size: 150,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              // Footer / Loading Status
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.xl),
                child: Column(
                  children: [
                    // Custom Loading dots
                    const _LoadingDots(),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      'LOADING DELICIOUSNESS',
                      style: theme.textTheme.labelLarge?.copyWith(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xxl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: AppDimensions.xs),
                        Text(
                          'Safe & Secure Campus Delivery',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> with SingleTickerProviderStateMixin {
  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _dotsController.dispose();
    super.dispose();
  }

  Widget _buildDot(int delayIndex) {
    final double begin = 0.3;
    final double end = 1.0;

    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        final double t = (_dotsController.value - (delayIndex * 0.16)).clamp(0.0, 1.0);
        final double scale = begin + (end - begin) * (1.0 - (t - 0.5).abs() * 2);
        final double opacity = begin + (end - begin) * (1.0 - (t - 0.5).abs() * 2);

        return Opacity(
          opacity: opacity.clamp(0.3, 1.0),
          child: Transform.scale(
            scale: scale.clamp(0.5, 1.2),
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(0),
        const SizedBox(width: 6),
        _buildDot(1),
        const SizedBox(width: 6),
        _buildDot(2),
      ],
    );
  }
}
