import 'package:flutter/material.dart';
import 'package:quickbit/core/constants/assets.dart';
import 'package:quickbit/core/constants/colors.dart';

class SplashIllustration extends StatelessWidget {
  final Animation<double> floatAnimation;

  const SplashIllustration({super.key, required this.floatAnimation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, floatAnimation.value),
          child: child,
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            AppAssets.splashIllustration,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.background,
              child: const Icon(
                Icons.delivery_dining,
                size: 150,
                color: AppColors.primary,
              ),
            ),
          ),
          // Dark gradient overlay for readability of elements on top
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
