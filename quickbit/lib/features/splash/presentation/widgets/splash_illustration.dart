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
    );
  }
}
