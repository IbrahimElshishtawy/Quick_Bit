import 'package:flutter/material.dart';
import 'package:quickbit/core/constants/colors.dart';
import 'package:quickbit/core/constants/dimensions.dart';

class OrderStatusStepper extends StatelessWidget {
  final int currentStep;

  const OrderStatusStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimelineStep(
          stepNumber: 0,
          title: 'Order Placed',
          subtitle: 'We have received your order.',
          isActive: currentStep >= 0,
          isCompleted: currentStep > 0,
        ),
        _buildTimelineStep(
          stepNumber: 1,
          title: 'Preparing Food',
          subtitle: 'The kitchen is preparing your meals.',
          isActive: currentStep >= 1,
          isCompleted: currentStep > 1,
        ),
        _buildTimelineStep(
          stepNumber: 2,
          title: 'Ready for Pickup',
          subtitle: 'Collect at student union locker station.',
          isActive: currentStep >= 2,
          isCompleted: currentStep > 2,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineStep({
    required int stepNumber,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isCompleted,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left side indicators
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? AppColors.primary
                      : (isActive ? AppColors.primaryContainer : AppColors.surfaceContainerHigh),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          (stepNumber + 1).toString(),
                          style: TextStyle(
                            color: isActive ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: VerticalDivider(
                    color: isCompleted ? AppColors.primary : AppColors.outlineVariant,
                    thickness: 2,
                    indent: 4,
                    endIndent: 4,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppDimensions.md),

          // Right side details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isActive ? AppColors.onSurface : AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isActive ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
