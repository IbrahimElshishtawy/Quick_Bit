import 'package:flutter/material.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';

class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.xl),
      child: Column(
        children: [
          // Custom Loading dots
          const LoadingDots(),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'LOADING DELICIOUSNESS',
            style: theme.textTheme.labelLarge?.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
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
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots> with SingleTickerProviderStateMixin {
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
