import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quickbit/core/usecases/usecase.dart';
import 'package:quickbit/injection_container.dart';
import 'package:quickbit/features/onboarding/domain/usecases/is_onboarding_completed.dart';
import 'package:quickbit/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:quickbit/features/login/presentation/pages/login_page.dart';
import 'package:quickbit/features/splash/presentation/widgets/splash_logo.dart';
import 'package:quickbit/features/splash/presentation/widgets/splash_illustration.dart';
import 'package:quickbit/features/splash/presentation/widgets/splash_footer.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          // Background Illustration
          Positioned.fill(
            child: SplashIllustration(
              floatAnimation: _floatAnimation,
            ),
          ),
          // Foreground Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header / Logo Area
                SplashLogo(
                  fadeInAnimation: _fadeInAnimation,
                  pulseAnimation: _pulseAnimation,
                ),

                // Spacer to keep logo at top and footer at bottom
                const Spacer(),

                // Footer / Loading Status
                const SplashFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
