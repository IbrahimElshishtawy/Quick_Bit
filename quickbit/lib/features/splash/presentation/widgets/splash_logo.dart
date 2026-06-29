import 'package:flutter/material.dart';
import 'package:quickbit/core/constants/assets.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';

class SplashLogo extends StatelessWidget {
  final Animation<double> fadeInAnimation;
  final Animation<double> pulseAnimation;

  const SplashLogo({
    super.key,
    required this.fadeInAnimation,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: fadeInAnimation,
      child: Column(
        children: [
          ScaleTransition(
            scale: pulseAnimation,
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
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
